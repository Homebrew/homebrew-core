class Surelog < Formula
  include Language::Python::Virtualenv

  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/chipsalliance/Surelog"
  url "https://github.com/chipsalliance/Surelog/archive/refs/tags/v1.82.tar.gz"
  sha256 "e2c4074f9d35b7a1450b722681d1557bdd4af3de09363dbdb9d0da9cf26b976b"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/Surelog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a53820eb2e8f416b332146f7e3c616187a6c3b962183657f897ed757a9bdcd1"
    sha256 cellar: :any,                 arm64_ventura:  "297da5c02b481e51156c07aec0a126f81fa2583ea7bb7fc6d73db8caaed246ab"
    sha256 cellar: :any,                 arm64_monterey: "2b5ec35feb22a015cce107b798e425917a5357b58f4f456bd442bf9ad0a69a06"
    sha256 cellar: :any,                 sonoma:         "4bd43bbdfbb80b32c836e692a4b8d50b54a6951077b4da4cb91f8ff7c53f13df"
    sha256 cellar: :any,                 ventura:        "0257da7a11bc5db39090ddd5e7e7a33c2ae802fa6a45e9c95ec96e7b868f70b2"
    sha256 cellar: :any,                 monterey:       "b9b594e8a310e04dc7107bde1f74ad00cf9720638933dc064e36bc0b682ff2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a43878bb272bdeb2ebcdf0593a78b01160cbb69fe1486add10ff98a06b8c41d7"
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
