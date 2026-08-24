class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.87.tar.gz"
  sha256 "877b74bf1a0ad5fc64f46df9e2af47a088e50b362469a36c5da5f96dc3926045"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fcbce8c33693e89df27c415e5ff8e84c814d0b521514629762ccc2930d2d8edf"
    sha256 cellar: :any, arm64_sequoia: "2347b003868577a54f2209b3a1e1fd2e04f568ade18197bcb8de8b7fa0732195"
    sha256 cellar: :any, arm64_sonoma:  "f7625c203f0179593070fb879c6db569ad2ccc8a5fbc935289ffe698736809db"
    sha256 cellar: :any, sonoma:        "23d836b3f21e4ee4edd378c70326108e6caf9517d2b3f73d1762b472317a4fd5"
    sha256 cellar: :any, arm64_linux:   "5283c0153383bf25cfed03aa78a3f6fccf415610d17c383644f8dbf2332e778f"
    sha256 cellar: :any, x86_64_linux:  "9ed54340103454bfba146eeeb9514899c73165e110d9e6a2d3429c468eb0303d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => :build
  depends_on "pkgconf" => :test
  depends_on "capnp"

  pypi_packages package_name:   "",
                extra_packages: "orderedmultidict"

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/5c/62/61ad51f6c19d495970230a7747147ce7ed3c3a63c2af4ebfdb1f6d738703/orderedmultidict-1.0.2.tar.gz"
    sha256 "16a7ae8432e02cc987d2d6d5af2df5938258f87c870675c73ee77a0920e6f4a6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def python3
    which("python3.14")
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DUHDM_BUILD_TESTS=OFF
      -DUHDM_USE_HOST_GTEST=ON
      -DUHDM_USE_HOST_CAPNP=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPython3_EXECUTABLE=#{buildpath}/venv/bin/python
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
