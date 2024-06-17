class Surelog < Formula
  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.83.tar.gz"
  sha256 "3add228495a6ef0e0e3921cb20c30ae09a32c04c76faab4f1a78e546e1d98d86"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "95cf3995027d36d2c86df419f3341ce30d92ef16e95ece9ed01aab03d2ceceae"
    sha256 cellar: :any,                 arm64_ventura:  "29c3c557786fd9d33250026372b3ddf8ef83b1191739d7c2893e2b777e3460a6"
    sha256 cellar: :any,                 arm64_monterey: "82363d3a40298dfc30497c5f15b866e0f7449419fb5d50657d910fe3a1d9c2d8"
    sha256 cellar: :any,                 sonoma:         "adde2f28100f1daefe024e60e4df424e0498c27961dcc0d7c40bbc6a3224d039"
    sha256 cellar: :any,                 ventura:        "2b18e6e0d005b03d528c80005244aa775ee210ca59b58a7fac3d5500d1b76799"
    sha256 cellar: :any,                 monterey:       "be420f7e49e3cfeeef09cc0a2ef91d4ef1c3532fdfa38d2c3533b1ed115ecbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f46a99a35b0df3f2eb6074db85834ecc1d0376ef3381e58c92f0ba7d65e5ecb"
  end

  depends_on "antlr" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openjdk" => :build
  depends_on "python@3.12" => :build
  depends_on "pkg-config" => :test
  depends_on "antlr4-cpp-runtime"
  depends_on "capnp"
  depends_on "uhdm"

  uses_from_macos "zlib"

  def install
    antlr = Formula["antlr"]
    system "cmake", "-S", ".", "-B", "build",
                    "-DANTLR_JAR_LOCATION=#{antlr.opt_prefix}/antlr-#{antlr.version}-complete.jar",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
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
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    flags = shell_output("pkg-config --cflags --libs Surelog").chomp.split
    system ENV.cxx, testpath/"test.cpp", "-o", "test",
                    "-L#{Formula["antlr4-cpp-runtime"].opt_prefix}/lib",
                    "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end
