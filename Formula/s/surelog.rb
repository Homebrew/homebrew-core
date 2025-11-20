class Surelog < Formula
  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.86.tar.gz"
  sha256 "5bffc61334f38b16b5dd57e5209d38bc1e07b0e0bda452e4580678aa3e9daf53"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "66093d81ba27bdec93164720b4ad7a74dff68180740febc45e38d69fdc71d9c1"
    sha256 cellar: :any,                 arm64_sequoia: "2370a598c0bd3f175e076cc279f4e1288b97d10d37ebb9e88997e43e6930aa70"
    sha256 cellar: :any,                 arm64_sonoma:  "d6f0e16d64bd3d7bd5288c4e67acac3f1c6532547383ba57fe9f79b911bfe5d1"
    sha256 cellar: :any,                 sonoma:        "414a3876730209a6dc97e206e8f364bd37a345c12483277b30ea8a7778ac0ac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d759aa138eb2002443d6881c6cf3bec1e6c7f1d78089417ddc079afaf75a198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "429877c5d363d0e611a33e01c5d77f88e2ac1c6253806b1c978581fa5e33cf21"
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

  uses_from_macos "zlib"

  conflicts_with "open-babel", because: "both install `roundtrip` binaries"

  def install
    antlr = Formula["antlr"]
    system "cmake", "-S", ".", "-B", "build",
                    "-DANTLR_JAR_LOCATION=#{antlr.opt_prefix}/antlr-#{antlr.version}-complete.jar",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPython3_EXECUTABLE=#{which("python3.14")}",
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
                    "-L#{Formula["antlr4-cpp-runtime"].opt_prefix}/lib",
                    "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end
