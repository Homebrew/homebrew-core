class Surelog < Formula
  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.84.tar.gz"
  sha256 "ddcbc0d943ee52f2487b7a064c57a8239d525efd9a45b1f3e3e4a96a56cb3377"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "85204e65ac92cea0739274b1836c7bae77eaf3005eb013ec20241dfe5500ba8d"
    sha256 cellar: :any,                 arm64_ventura:  "2ff2bedf7480466f17c675bb0a34882222158d8b4d460b72bb4aa2082cffb8e4"
    sha256 cellar: :any,                 arm64_monterey: "9325935c4d32f32009230864c7418d73ac42a373978f068751437914f898e72b"
    sha256 cellar: :any,                 sonoma:         "2400e046712df69761721f69f70017ad1d4e9880ba91377589e792428e2de399"
    sha256 cellar: :any,                 ventura:        "5310dfc346c2bff4520151aecf9c942b1908bbaff85a4e7c57221bdf71a0aaf1"
    sha256 cellar: :any,                 monterey:       "f71d7d68cc8be8de38a47dfdde9a93163f78bd8b67babc5c6206cbf2b576f986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5b576e3198b44eaefa5b52736ddbf80d8e314c40261f3d3cb60c096b069675c"
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

  conflicts_with "open-babel", because: "both install `roundtrip` binaries"

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
