class Surelog < Formula
  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.92.tar.gz"
  sha256 "496f0dd10ad8635ff4c5007333f9b8de57f79c19388ed857a30953406614e369"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    manifest_sha256 "eb3e914a718229ab4b5c9e2396f561ee2f324240c9c7d4f3b22089e726f49f2c"
    sha256 cellar: :any, arm64_golden_gate: "8c6c3fecfb546cae179b5845570ed9a9b73908b172239b064b1b90f0b0098cec"
    sha256 cellar: :any, arm64_tahoe:       "99266b1b00cbd10403667e6abd7a37e44eda7d086360f0392d67fe64273749a4"
    sha256 cellar: :any, arm64_sequoia:     "db95a0598fddc225982b54945dd160ca4bc0d66fa26282eaebe3e121cdb20f45"
    sha256 cellar: :any, arm64_linux:       "15c7ba033dd2529514934d9fc8ebe0e0eec8184329d238f0a66a44de198d4b3e"
    sha256 cellar: :any, x86_64_linux:      "4476e83ebdf1d39b9221a37101b60f7bc7b827fd041ff345b8ef6c3e71c847b1"
  end

  depends_on "antlr" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :test
  depends_on "antlr4-cpp-runtime"
  depends_on "capnp"
  depends_on "uhdm"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "open-babel", because: "both install `roundtrip` binaries"

  deny_network_access!

  def install
    antlr = Formula["antlr"]
    args = %W[
      -DANTLR_JAR_LOCATION=#{antlr.opt_prefix}/antlr-#{antlr.version}-complete.jar
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DSURELOG_BUILD_TESTS=OFF
      -DSURELOG_USE_HOST_ALL=ON
      -DSURELOG_WITH_ZLIB=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
