class Surelog < Formula
  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.87.tar.gz"
  sha256 "5d3895ebaa08890db858988143264e2bc84c1dc6d36344628dc9f4a2aee2027b"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "547b3f5a886b3dcc10d263a695f2152995c537de2216e8395b4c43e8ad26a35c"
    sha256 cellar: :any, arm64_sequoia: "de8bb0dc0784c3ef42a0722424bc6adcb82bb05224a2829d8d7191661b1481c1"
    sha256 cellar: :any, arm64_sonoma:  "6fb741dd920be55b4406225fe0b09be7c5d3ed1b9c0a486ea59d9da5fc7b66ef"
    sha256 cellar: :any, sonoma:        "f1fd02f85390a41a18e256426a2a413d54835b446120942ec205eb258494714c"
    sha256 cellar: :any, arm64_linux:   "e1cc82bbb403c7151ae60ccae58bb734938a01c50426756abc23b9b86a9a3b8f"
    sha256 cellar: :any, x86_64_linux:  "a4a163f552028171132efe8e46165bb09113d615f307d457df4176098b24d5ca"
  end

  depends_on "antlr" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openjdk" => :build
  depends_on "python@3.14" => :build
  depends_on "pkgconf" => :test
  depends_on "antlr4-cpp-runtime"
  depends_on "capnp"
  depends_on "uhdm"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "open-babel", because: "both install `roundtrip` binaries"

  def install
    antlr = Formula["antlr"]
    system "cmake", "-S", ".", "-B", "build",
                    "-DANTLR_JAR_LOCATION=#{antlr.opt_prefix}/antlr-#{antlr.version}-complete.jar",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPython3_EXECUTABLE=#{python3}",
                    "-DSURELOG_BUILD_TESTS=OFF",
                    "-DSURELOG_USE_HOST_ALL=ON",
                    "-DSURELOG_WITH_ZLIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # ensure linking is ok
    system bin/"surelog", "--version"

    # ensure library is ok
    (testpath/"test.cpp").write <<~CPP
      #include <Surelog/API/Surelog.h>
      #include <Surelog/CommandLine/CommandLineParser.h>
      #include <Surelog/Common/FileSystem.h>
      #include <Surelog/Design/Design.h>
      #include <Surelog/Design/ModuleInstance.h>
      #include <Surelog/ErrorReporting/ErrorContainer.h>
      #include <Surelog/SourceCompile/SymbolTable.h>
      #include <functional>
      #include <iostream>
      #include <uhdm/uhdm.h>
      int main(int argc, const char** argv) {
        uint32_t code = 0;
        SURELOG::SymbolTable* symbolTable = new SURELOG::SymbolTable();
        SURELOG::ErrorContainer* errors = new SURELOG::ErrorContainer(symbolTable);
        SURELOG::CommandLineParser* clp =
            new SURELOG::CommandLineParser(errors, symbolTable, false, false);
        clp->noPython();
        bool success = clp->parseCommandLine(argc, argv);
        errors->printMessages(clp->muteStdout());
        SURELOG::Design* the_design = nullptr;
        SURELOG::scompiler* compiler = nullptr;
        if (success && (!clp->help())) {
          compiler = SURELOG::start_compiler(clp);
          the_design = SURELOG::get_design(compiler);
          auto stats = errors->getErrorStats();
          code = (!success) | stats.nbFatal | stats.nbSyntax | stats.nbError;
        }
        if (the_design) {
          for (auto& top : the_design->getTopLevelModuleInstances()) {
            std::function<void(SURELOG::ModuleInstance*)> inst_visit =
              [&inst_visit](SURELOG::ModuleInstance* inst) {
                SURELOG::FileSystem* const fileSystem =
                  SURELOG::FileSystem::getInstance();
                  std::cout << "Inst: " << inst->getFullPathName() << std::endl;
                  std::cout << "File: " << fileSystem->toPath(inst->getFileId())
                    << std::endl;
              for (uint32_t i = 0; i < inst->getNbChildren(); i++) {
                inst_visit(inst->getChildren(i));
              }
            };
            inst_visit(top);
          }
        }
        if (success && (!clp->help())) {
          SURELOG::shutdown_compiler(compiler);
        }
        delete clp;
        delete symbolTable;
        delete errors;
        return code;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs Surelog").chomp.split
    system ENV.cxx, testpath/"test.cpp", "-o", "test",
                    "-L#{formula_opt_prefix("antlr4-cpp-runtime")}/lib",
                    "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end
