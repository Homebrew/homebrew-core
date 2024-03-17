class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.82.tar.gz"
  sha256 "f33d62a1ae0381389b4bc89f639e127bb04557bfdd2f8ff4f57e2f7b5df2e80f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f91d05e4ec4b72199008297cb73d651d218e9b5b7b4a2b5c51a7de0e864c7eb"
    sha256 cellar: :any,                 arm64_ventura:  "ce41d2ab687f45b38ea6d5408d0560690e52a68e248bd01158fb0038f361f172"
    sha256 cellar: :any,                 arm64_monterey: "9d9feb7a7b6d3017db91a306319776866db63333d8a86380178542df7c00ed51"
    sha256 cellar: :any,                 sonoma:         "a6a74475a3975b6c6e3b4151e20c65597c6457026bc8c0571ca3acfadd5e1d8f"
    sha256 cellar: :any,                 ventura:        "6a3095c1789ded384ff74e025193686746ca2fcdb654048c1fede1c4fc5a5da8"
    sha256 cellar: :any,                 monterey:       "2d07d5f6f63a84a517df15863a310f86a2582e3ba861acde3b6910184e4b30ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb024b76fa50e900926b02667f7bae9fa85c35d6490a22f7f1390d05d12d3a07"
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
    resources.each do |r|
      venv.pip_install r
    end
    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
      "-DBUILD_SHARED_LIBS=ON",
      "-DUHDM_BUILD_TESTS=OFF",
      "-DUHDM_USE_HOST_GTEST=ON",
      "-DUHDM_USE_HOST_CAPNP=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python", *std_cmake_args
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
    system ENV.cxx, testpath/"test.cpp", "-o", "test",
      "-fPIC", "-std=c++17", *flags
    system testpath/"test"
  end
end
