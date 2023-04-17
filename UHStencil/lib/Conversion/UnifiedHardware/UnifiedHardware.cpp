#include <vector>
#include <memory.h>
#include <string>
#include "Conversion/UnifiedHardware/UnifiedHardware.h"

namespace {

class UnifiedCommunication
{
private:
    double bandwidth;
    double latency;

public:
    UnifiedCommunication(double bandwidth_, double latency_)
    : bandwidth(bandwidth_), latency(latency_)
    {}
    ~UnifiedCommunication();
};


class UnifiedLevel
{
public:
    std::string label;
    
    int level;
    // 该层次是否有真正的执行单元，是否能执行代码
    bool isVirtual;
private:
    
    // 该层次的计算单元
    std::vector<std::shared_ptr<UnifiedComputeUnit>> computeUnits;
    // 该层次的 memory
    std::vector<std::shared_ptr<UnifiedMemory>> memorys;
public:
    UnifiedLevel(string label_, int level_, bool isVirtual_)
    : label(label_), level(level_), virtual(virtual_)
    {}
    ~UnifiedLevel();
};



class UnifiedMemory {
private:
    bool readOnly;
    std::string name;
    int level;
    // bytes
    u_int64_t size;
    Layout layout;
    // 可以访问该 memory 的计算单元（或层次）
    std::vector<std::shared_ptr<UnifiedComputeUnit>> accessedBy;
    // 从这些 memory 加载数据的通信属性
    std::unordered_map<std::shared_ptr<UnifiedMemory>, std::shared_ptr<UnifiedCommunication>> loadFrom;
    // 存储至这些 memory 的通信属性
    std::unordered_map<std::shared_ptr<UnifiedMemory>, std::shared_ptr<UnifiedCommunication>> storeTo;

public:
    UnifiedMemory(string name_, int level_, u_int64_t size_, Layout layout_, bool readOnly_ = false)
    : name(name_), level(level_), size(size_), layout(layout_), readOnly(readOnly_)
    {}
    ~UnifiedMemory();

    bool isConstant() const { return readOnly; }
    string getName() const { return name; }
    int getLevel() const { return level; }
    u_int64_t getSize() const { return size; }
    Layout getLayout() const { return layout; }
    // std::shared_ptr<UnifiedMemory>
    std::shared_ptr<UnifiedCommunication> getLoadAttr(std::shared_ptr<UnifiedMemory> mem) const { return loadFrom[mem] }
    std::shared_ptr<UnifiedCommunication> getStoreAttr(std::shared_ptr<UnifiedMemory> mem) const { return storeTo[mem] }
    void addMemoryToLoadFrom(std::shared_ptr<UnifiedMemory> mem, std::shared_ptr<UnifiedCommunication> communication);
    void addMemoryToStoreTo(std::shared_ptr<UnifiedMemory> mem, std::shared_ptr<UnifiedCommunication> communication);
    
};

class UnifiedComputeUnit {
private:
    /* data */
    string name;
    int level;

    // 子计算单元的个数
    // u_int32_t size;
    
    // sub-cluster 的布局
    // std::vector<int> dimensions;

    // attachedMemory 默认为空，表示可以基于 level 层次的 memory 进行计算；
    // 若不为空，则只能在 attached memory 上进行计算，比如 tensor core 只能基于 fragment 进行计算
    std::vector<std::shared_ptr<UnifiedMemory>> attachedMemory;

    // 子计算单元，及对应的数量
    std::unordered_map<std::shared_ptr<UnifiedComputeUnit>, int> subComputeUnits;

    // TODO: basic_func 
    // TODO: func

public:
    UnifiedComputeUnit(string name_, int level_, u_int32_t size_)
    : name(name_), level(level_), size(size_)
    {}
    ~UnifiedComputeUnit();
};

class UnifiedHardware {
    std::vector<UnifiedLevel*> levels;
};

} // namespace