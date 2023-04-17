#ifndef __UNIFIED_HARDWARE_H__
#define __UNIFIED_HARDWARE_H__

#include <vector>
#include <memory.h>
#include <string>
// #include <unordered_map>


namespace {

enum Layout {
    ROW = 0,
    COL = 1
};

class UnifiedCommunication;
class UnifiedLevel;
class UnifiedMemory;
class UnifiedComputeUnit;
class UnifiedHardware;

// class UnifiedCommunication
// {
// private:
//     double bandwidth;
//     double latency;

// public:
//     UnifiedCommunication(double bandwidth_, double latency_)
//     : bandwidth(bandwidth_), latency(latency_)
//     {}
//     ~UnifiedCommunication();
// };


class UnifiedLevel
{
public:
    std::string label;
    
    int level;
    // 该层次是否有真正的执行单元，是否能执行代码
    bool isVirtual;
    std::vector<int> dimensions; 
    int num_dimension = 1;
private:
    
    // // 该层次的计算单元
    // std::vector<UnifiedComputeUnit*> computeUnits;
    // // 该层次的 memory
    // std::vector<UnifiedMemory*> memorys;
public:
    UnifiedLevel(std::string label_, int level_, bool isVirtual_ = false, int num_dim = 1)
    : label(label_), level(level_), isVirtual(isVirtual_), num_dimension(num_dim),
      dimensions(std::vector<int>(num_dim, 1))
    {}
    // ~UnifiedLevel();
};



// class UnifiedMemory {
// private:
//     bool readOnly;
//     std::string name;
//     int level;
//     // bytes
//     u_int64_t size;
//     Layout layout;
//     // 可以访问该 memory 的计算单元（或层次）
//     std::vector<UnifiedComputeUnit*> accessedBy;
//     // 从这些 memory 加载数据的通信属性
//     std::unordered_map<UnifiedMemory*, UnifiedCommunication*> loadFrom;
//     // 存储至这些 memory 的通信属性
//     std::unordered_map<UnifiedMemory*, UnifiedCommunication*> storeTo;

// public:
//     UnifiedMemory(string name_, int level_, u_int64_t size_, Layout layout_, bool readOnly_ = false)
//     : name(name_), level(level_), size(size_), layout(layout_), readOnly(readOnly_)
//     {}
//     ~UnifiedMemory();

//     bool isConstant() const { return readOnly; }
//     string getName() const { return name; }
//     int getLevel() const { return level; }
//     u_int64_t getSize() const { return size; }
//     Layout getLayout() const { return layout; }
//     // std::shared_ptr<UnifiedMemory>
//     UnifiedCommunication* getLoadAttr(UnifiedMemory* mem) const { return loadFrom[mem] }
//     UnifiedCommunication* getStoreAttr(UnifiedMemory* mem) const { return storeTo[mem] }
//     void addMemoryToLoadFrom(UnifiedMemory mem*, UnifiedCommunication* communication);
//     void addMemoryToStoreTo(UnifiedMemory mem*, UnifiedCommunication* communication);
    
// };

// class UnifiedComputeUnit {
// private:
//     /* data */
//     std::string label;
//     int level;

//     // 子计算单元的个数
//     u_int32_t size;
    
//     // sub-cluster 的布局
//     // std::vector<int> dimensions;

//     // attachedMemory 默认为空，表示可以基于 level 层次的 memory 进行计算；
//     // 若不为空，则只能在 attached memory 上进行计算，比如 tensor core 只能基于 fragment 进行计算
//     std::vector<UnifiedMemory*> attachedMemory;

//     // 子计算单元，及对应的数量
//     std::unordered_map<UnifiedComputeUnit*, int> subComputeUnits;

//     // TODO: basic_func 
//     // TODO: func

// public:
//     UnifiedComputeUnit(string label_, int level_, u_int32_t size_)
//     : label(label_), level(level_), size(size_)
//     {}
//     ~UnifiedComputeUnit();
// };

class UnifiedHardware {
 public:
    std::vector<UnifiedLevel*> levels;
    int num_level;
    std::string name;
};

} // namespace

namespace UH {
UnifiedHardware* _gpu;
UnifiedHardware* _sw;

void instantial () {
    // instantial gpu
    {
        _gpu = new UnifiedHardware;
        _gpu -> num_level = 2;
        _gpu -> name = "gpu";
        auto& gpuLevels = _gpu -> levels;

        // device 包含 global memory
        // device 包含多个 SM，但是下一层 block 的数目不受此限制
        // UnifiedLevel* device = new UnifiedLevel("device", 1, false, 1);
        UnifiedLevel* device = new UnifiedLevel("grid", 1, false, 3);

        // block 包含 shared memory，也可直接访问 global memory
        // block 包含的计算单元：cuda core（设置为可调？）、tensor core
        UnifiedLevel* block = new UnifiedLevel("block", 2, false, 3);

        // thread 包含 register，也可直接访问 global memory / shared memory
        UnifiedLevel* thread = new UnifiedLevel("thread", 3, false, 1);
        

        // UnifiedLevel* host = new UnifiedLevel("host", 0, true, 1);
        // UnifiedLevel* device = new UnifiedLevel("device", 1, false, 1);
        // UnifiedLevel* SM = new UnifiedLevel("SM", 2, false, 3);

        (thread->dimensions)[0] = 1; 
        gpuLevels.push_back(device);
        gpuLevels.push_back(block);
        // gpuLevels.push_back(thread);

        // gpuLevels.push_back(host);
        // gpuLevels.push_back(device);
        // gpuLevels.push_back(SM);
    }
    // instantial sw
    {
        _sw = new UnifiedHardware;
        _sw -> num_level = 1;
        _sw -> name = "sw";
        auto& swLevels = _sw -> levels;
        UnifiedLevel* cpe = new UnifiedLevel("cpe", 1, false, 3);
        UnifiedLevel* thread = new UnifiedLevel("thread", 2, false, 1);
        // (cpe->dimensions)[0] = 8;
        // (cpe->dimensions)[1] = 8;
        (thread->dimensions)[0] = 1; 
        swLevels.push_back(cpe);
        // swLevels.push_back(thread);
    }
}

}
#endif