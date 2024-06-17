class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.83.tar.gz"
  sha256 "4b02ccf8dede2074f0906e1a447ebfd2af7e6774b518ccefcc52b6401200c658"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f01a0475c1188c359c90b7d1754bb9340f53b8f305fc72a6eb07850656d3424e"
    sha256 cellar: :any,                 arm64_ventura:  "68018fcc5c3db759937c2176d70dcbabe385605e430f5c5549e1ebb77c993696"
    sha256 cellar: :any,                 arm64_monterey: "9b5c9f7cf6c9fed8de1f92d2300ba4c3776b65323b3908838921a61abc52e5fa"
    sha256 cellar: :any,                 sonoma:         "1929f703df41e2983241fb570bf0d296d3cd8f20b9c000fea3a9695483d33588"
    sha256 cellar: :any,                 ventura:        "07948bb5417743c768bd0d78b8931874873f388eaf6b096fc60493f4a6e36d2a"
    sha256 cellar: :any,                 monterey:       "4102e88b6b3402767479ba292e674d4cb1b73eb49dce7c476fe843cca524724f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "882a02cbaa8b7aa427abe876c397c86063020e3851ffa121b163985000248036"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
  depends_on "pkg-config" => :test
  depends_on "capnp"

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DUHDM_BUILD_TESTS=OFF",
                    "-DUHDM_USE_HOST_GTEST=ON",
                    "-DUHDM_USE_HOST_CAPNP=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python",
                    *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    # Create a minimal .uhdm file and ensure executables work
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <stdlib.h>
      #include "uhdm/constant.h"
      #include "uhdm/uhdm.h"
      #include "uhdm/uhdm_types.h"  // for uhdmconstant
      #include "uhdm/vhpi_user.h"   // vpi_user functions.
      #include "uhdm/vpi_uhdm.h"    // struct uhdm_handle
      int main() {
        UHDM::Serializer serializer;
        UHDM::constant *value = serializer.MakeConstant();
        value->VpiFile("hello.v");
        value->VpiLineNo(42);
        value->VpiSize(12345);
        value->VpiDecompile("decompile");
        uhdm_handle uhdm_handle(UHDM::uhdmconstant, value);
        vpiHandle vpi_handle = (vpiHandle)&uhdm_handle;
        assert(vpi_get_str(vpiFile, vpi_handle) == std::string("hello.v"));
        assert(vpi_get(vpiLineNo, vpi_handle) == 42);
        assert(vpi_get(vpiSize, vpi_handle) == 12345);
        assert(vpi_get_str(vpiDecompile, vpi_handle) == std::string("decompile"));
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs UHDM").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end
