class Surelog < Formula
  include Language::Python::Virtualenv

  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.76.tar.gz"
  sha256 "ddef62ff38f25bb1816f592b2ad0040507bbcdb268102b9b7555f592701a22dc"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a022b3479e95c96d341746a90d554cd4b41f71d764c15b67ea41b89b82f0d63f"
    sha256 cellar: :any,                 arm64_ventura:  "3ff8af7b51b4a80371ffad7d4b8c27a49587de8fe079b109cc6c50fcd52cd84b"
    sha256 cellar: :any,                 arm64_monterey: "df721f0af8e49a5dc1e237228bdb3468da75563390316310b708a0d32a481295"
    sha256 cellar: :any,                 sonoma:         "dd0a02da6f3032e3dcb55247a5d28e744c2fa140bf67f97b2a69fc14a85fed53"
    sha256 cellar: :any,                 ventura:        "9a9cc3fc52eea6aff7da2da74916dad07a935f71981b3fe9fed891554dc884ea"
    sha256 cellar: :any,                 monterey:       "709fd825fa92150cb1ed87461f7646ec1230f8a9d3a15e47eea44a0cbefbd37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828542efb0bb2f91c4606fad86fdded47f1854f4f7267a08ba3cd660e01dc405"
  end

  depends_on "antlr" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openjdk" => :build
  depends_on "python@3.12" => :build
  depends_on "six" => :build
  depends_on "googletest" => :test
  depends_on "pkg-config" => :test
  depends_on "antlr4-cpp-runtime"
  depends_on "capnp"
  depends_on "uhdm"

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    resources.each do |r|
      venv.pip_install r
    end

    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
      "-DBUILD_SHARED_LIBS=ON",
      "-DSURELOG_BUILD_TESTS=OFF",
      "-DSURELOG_USE_HOST_GTEST=ON",
      "-DSURELOG_USE_HOST_ANTLR=ON",
      "-DSURELOG_USE_HOST_CAPNP=ON",
      "-DSURELOG_USE_HOST_JSON=ON",
      "-DSURELOG_USE_HOST_UHDM=ON",
      "-DGTEST_LIBRARY=unused",
      "-DGTEST_INCLUDE_DIR=unused",
      "-DGTEST_MAIN_LIBRARY=unused",
      "-DANTLR_JAR_LOCATION=#{Formula["antlr"].opt_prefix}/antlr-#{Formula["antlr"].version}-complete.jar",
      "-DSURELOG_WITH_ZLIB=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
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
