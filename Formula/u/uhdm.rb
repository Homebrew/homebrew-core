class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.92.tar.gz"
  sha256 "69a37ee8b9c9c160af0b4cc07c193603eb903d68cb538b19d01d38e41161ebaf"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    manifest_sha256 "4b4143f1a895f5dad390710bee34c7f1b1912fb566f4c32c3fda24fad18a32e6"
    sha256 cellar: :any, arm64_golden_gate: "6f126d47feac1cdb059cd11a12ff60a2c2ce51f19d5582d06b4f5013d663bff0"
    sha256 cellar: :any, arm64_tahoe:       "b8c198a56977f5bc9b15700387e9b1eb37908cf4a726db928b9f62e3c096017e"
    sha256 cellar: :any, arm64_sequoia:     "3b98b4d10b968bd86b0063ba35fac45d725c2f08f01171584612cd3ac1a8e992"
    sha256 cellar: :any, arm64_linux:       "b4f848b288c894890e6d20d0cf87f906f367b25d4f1068c06e673cf676280c79"
    sha256 cellar: :any, x86_64_linux:      "93602990960f10c31bb5c8a866e78610435afd5e4eb5518c3c659cf621229950"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => :build
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

  deny_network_access!

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources, build_isolation: false

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
