class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.91.tar.gz"
  sha256 "305bbc03ad9c22eec517788d365799c2dfa3427acea3b59ded9bc2e67f253de8"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    manifest_sha256 "e2571b0342901fdfac91b8be50ddaeb9ba71ce2109336d3c252b0a6c8d0171a3"
    sha256 cellar: :any, arm64_golden_gate: "97eb8bb45a400c3273ea52c38497cfb9e7095d0318030f73584a126a393cc0e9"
    sha256 cellar: :any, arm64_tahoe:       "93156a9e6143f19e65d70f44a1a87b67dd6095efbf38e6b056bdb0bc66f993e0"
    sha256 cellar: :any, arm64_sequoia:     "8a0b591926b82a999df145f92c9b22f54a32c23fb70e2375369e532319157478"
    sha256 cellar: :any, arm64_linux:       "7dbb0ba8c3c0489ac31552ccd6083cb8eee98cfd14eaa299454aa60003a11645"
    sha256 cellar: :any, x86_64_linux:      "1926ec1744d433ea87ab31a161a88ffbe3f5039d31e3dba0831b55339f4a648c"
  end

  depends_on "cmake" => :build
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
