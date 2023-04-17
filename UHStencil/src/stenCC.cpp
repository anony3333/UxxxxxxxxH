/**
 * @file stenCC.cpp
 * @author 
 * @brief 主程序
 * @version 0.1
 * @date 2022-0912
 * 
 * @copyright Copyright (c) HiPO Beihang University 2022
 * 
 */

#include <mlir/Dialect/GPU/GPUDialect.h>
#include <mlir/Dialect/SCF/SCF.h>
#include <mlir/Dialect/StandardOps/IR/Ops.h>
#include <mlir/IR/AsmState.h>
#include <mlir/InitAllDialects.h>
#include <mlir/InitAllPasses.h>
#include <mlir/Pass/Pass.h>
#include <mlir/Pass/PassManager.h>
#include <mlir/Support/MlirOptMain.h>
#include <mlir/Parser.h>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/SourceMgr.h>
#include <mlir/Support/DebugCounter.h>

#include "Parser/Parser.h"
#include "Parser/MLIRGen.h"

#include "Dialect/Stencil/StencilDialect.h"
#include "Dialect/SW/SWDialect.h"
#include "Dialect/Stencil/Passes.h"
// #include "Conversion/LLVMEmitCAttr/Passes.h"
#include "Conversion/StencilToSW/Passes.h"
#include "Conversion/StandardToSW/Passes.h"
#include "Conversion/StencilToStandard/Passes.h"
#include "Conversion/UHAffineToParallel/Passes.h"
#include "Conversion/LoopsToGPU/Passes.h"
// #include "Conversion/StencilToVector/Passes.h"

using namespace mlir;
using namespace swsten;

namespace cl = llvm::cl;
static cl::opt<std::string> inputFilename(cl::Positional,
                                          cl::desc("<input StenDSL file>"),
                                          cl::init("-"),
                                          cl::value_desc("filename"));

namespace {
    enum InputType {Stencil, MLIR };
}
static cl::opt<enum InputType> inputType(
    "x", cl::init(Stencil), cl::desc("Decided the kind of input desired"), 
    cl::values(clEnumValN(Stencil, "stencil", "load the input file as a Stencil source file")),
    cl::values(clEnumValN(MLIR, "mlir", "load the input file as an MLIR file")));

// 自定义选项
namespace {
enum Action {
    None,
    DumpAST,
    DumpMLIR
    // ConvertLLVM
};
}
static cl::opt<enum Action> emitAction(
    "emit", cl::desc("Select the kind of outpput desired"),
    cl::values(clEnumValN(DumpAST, "ast", "output the AST dump")),
    cl::values(clEnumValN(DumpMLIR, "gpu", "output the MLIR dump"))
);

static cl::opt<bool> verifyPasses(
    "verify-each",
    cl::desc("Run the verifier after each transformation pass"),
    cl::init(true));

// 解析输入的文件, 并构造抽象语法树, 如果发生错误则返回nullptr
std::unique_ptr<swsten::ModuleAST> parseInputFile(llvm::StringRef filename) {
    llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> fileOrErr = 
        llvm::MemoryBuffer::getFileOrSTDIN(filename);
    
    if (std::error_code ec = fileOrErr.getError()) {
        llvm::errs() << "Could not open input file: " << ec.message() << "\n";
        return nullptr;
    }

    auto buffer = fileOrErr.get()->getBuffer();
    LexerBuffer lexer(buffer.begin(), buffer.end(), std::string(filename));
    Parser parser(lexer);

    return parser.parseModule();
}

int dumpAST() {
    if (inputType == InputType::MLIR) {
        llvm::errs() << "Can't dump a Stencil AST when the input is MLIR\n";
        return -1;
    }

    auto moduleAST = parseInputFile(inputFilename);
    if (!moduleAST)
        return -1;
    
    dump(*moduleAST);

    return 0;
}

// 加载文件
int loadMLIR(mlir::MLIRContext &context, mlir::OwningModuleRef &module) {
    // 处理'sten'输入
    if (inputType == Stencil &&
        llvm::StringRef(inputFilename).endswith(".dsl")) {
        auto moduleAST = parseInputFile(inputFilename);
        if (!moduleAST)
            return -1;
        module = mlirGen(context, *moduleAST);
        return !module ? 1 : 0;
    }

    // 否则, 输入'.mlir'
    llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> fileOrErr =
        llvm::MemoryBuffer::getFileOrSTDIN(inputFilename);
    if (std::error_code EC = fileOrErr.getError()) {
        llvm::errs() << "Could not open input file: " << EC.message() << "\n";
        return -1;
    }

    // 解析输入的mlir文件
    llvm::SourceMgr sourceMgr;
    sourceMgr.AddNewSourceBuffer(std::move(*fileOrErr), llvm::SMLoc());
    module = mlir::parseSourceFile(sourceMgr, &context);
    if (!module) {
        llvm::errs() << "Error can't load file " << inputFilename << "\n";
        return -1;
    }

    return 0;
}

LogicalResult uhstencilMain(int argc, char **argv, llvm::StringRef toolName,
                                DialectRegistry &registry) {
    // Register any command line options.
    registerAsmPrinterCLOptions();
    registerMLIRContextCLOptions();
    registerPassManagerCLOptions();
    DebugCounter::registerCLOptions();
    PassPipelineCLParser passPipeline("", "Compiler passes to run");

    // Parse pass names in main to ensure static initialization completed.
    cl::ParseCommandLineOptions(argc, argv, "UHStencil compiler\n");

    if (emitAction == Action::DumpAST)
        return dumpAST() ? failure() : success();
    
    // 如果不是打印AST, 则需要将其转换为MLIR
    mlir::MLIRContext context;
    // 加载stencil Dialect
    context.getOrLoadDialect<mlir::stencil::StencilDialect>();
    context.getOrLoadDialect<mlir::StandardOpsDialect>();
    context.getOrLoadDialect<scf::SCFDialect>();
    context.getOrLoadDialect<mlir::AffineDialect>();
    context.getOrLoadDialect<mlir::sw::SWDialect>();
    context.getOrLoadDialect<memref::MemRefDialect>();
    context.getOrLoadDialect<mlir::gpu::GPUDialect>();
    mlir::OwningModuleRef module;


    // Disable multi-threading when parsing the input file. This removes the
    // unnecessary/costly context synchronization when parsing.
    bool wasThreadingEnabled = context.isMultithreadingEnabled();
    context.disableMultithreading();
    // 加载文件
    if(loadMLIR(context, module))
        return failure();
    
    context.enableMultithreading(wasThreadingEnabled);
    // Apply any pass manager command line options.
    PassManager pm(&context, OpPassManager::Nesting::Implicit);
    pm.enableVerifier(verifyPasses);
    applyPassManagerCLOptions(pm);
    
    auto errorHandler = [&](const Twine &msg) {
        emitError(UnknownLoc::get(&context)) << msg;
        return failure();
    };
    // Build the provided pipeline.
    if (failed(passPipeline.addToPipeline(pm, errorHandler)))
        return failure();

    // Run the pipeline.
    if (failed(pm.run(*module)))
        return failure();
    module->dump();
    return success();
}

int main(int argc, char *argv[])
{

    // llvm::InitLLVM y(argc, argv);

    //registerAllDialects();
    registerAllPasses();

    registerStencilPasses();
    registerStencilToStandardConversionPasses();
    registerUHAffineToParallelConversionPasses();
    registerMLIRLoopsToGPUConversionPasses();
    registerStencilToSWConversionPasses();
    registerStandardToSWConversionPasses();
    // registerLowerToLLVMPasses();

    mlir::DialectRegistry registry;
    registry.insert<mlir::stencil::StencilDialect>();
    registry.insert<mlir::StandardOpsDialect>();
    registry.insert<scf::SCFDialect>();
    registry.insert<mlir::AffineDialect>();
    registry.insert<mlir::sw::SWDialect>();
    registry.insert<mlir::gpu::GPUDialect>();
    registerAllDialects(registry);

    return failed(uhstencilMain(argc, argv, 
            "UHStencil, a stencil compiler for unified hardware\n", registry));
}
