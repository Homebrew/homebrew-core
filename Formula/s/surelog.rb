class Surelog < Formula
  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.92.tar.gz"
  sha256 "496f0dd10ad8635ff4c5007333f9b8de57f79c19388ed857a30953406614e369"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    manifest_sha256 "f7e055de48675d1879208b82150cbae9015979a678427bf17d3f51531b9411b9"
    sha256 cellar: :any, arm64_golden_gate: "42e9e6d3850146dd6b854f2aa4cec71f2ecb01ad3f9d55343e8ffdc4944d9be6"
    sha256 cellar: :any, arm64_tahoe:       "dbabc1de4111df046a02ec53e226592d4d57bab28874a366aa3572ae405ae0f8"
    sha256 cellar: :any, arm64_sequoia:     "6772da5986f78b59970c396efa99b047ff0f5fbc6be86be4e2df6b9b498ce3df"
    sha256 cellar: :any, arm64_linux:       "0f512cd9ad6d95e0efeb42bdd88fe7680d177ee33f31dfac61e2029197c479cc"
    sha256 cellar: :any, x86_64_linux:      "3713bcf19aa859b8b1aa0abf0665007c37abe8b128adff5a9bc7e7da37162187"
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
