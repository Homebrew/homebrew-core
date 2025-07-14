class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.84.tar.gz"
  sha256 "bb2acbdd294dd05660c78ba34704440032935b8bc77cae352c853533b5a7c583"
  license "Apache-2.0"
  revision 2
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19fcc355f0c97b73f365f5f8dc5ce72eefa83d08b780553058da783ddacb917d"
    sha256 cellar: :any,                 arm64_sonoma:  "812e9c2b03de83b4def63dc9c34412106a3ba5ab01bfb9da42b8a9756458cb2c"
    sha256 cellar: :any,                 arm64_ventura: "dcfd52eac15acef073c1959bf116f6bfe5974a571a67748377ae8ec61f02c369"
    sha256 cellar: :any,                 sonoma:        "09774eae01e08f62741390bcc1bbbcbb1d96896c7caccfaeb1ac36cad38695c9"
    sha256 cellar: :any,                 ventura:       "5100d3f029ce0a76ef2c1c98b0436fa96a448032cc233565f24f1d641c13967b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2fe27ffa31d6ce11379a222b847493950059f02d02b493618b549a8ef27a81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d68f2dc934db9fd61b5048294bff8299b638c36bde5b56b4111e2c84c828fb2"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
  depends_on "pkgconf" => :test
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
    which("python3.13")
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    flags = shell_output("pkg-config --cflags --libs UHDM").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end
