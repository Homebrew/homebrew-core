class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.76.tar.gz"
  sha256 "72fffa0f53632716536ad70495749f460f90903650d41fe4d11e454b8b7de68a"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5404b860df06e17d87552d0e98f7afba95fc4e71fe31370e7df0c55ecebf1690"
    sha256 cellar: :any,                 arm64_ventura:  "0a311e894647c4c2a2da45e3c2a91c2edb7bc32f19a85b29dca95d4d40d78945"
    sha256 cellar: :any,                 arm64_monterey: "72314681085aee06c4a99d0c5e202b388eacf34963c0e93bd72d2fa522b70b18"
    sha256 cellar: :any,                 sonoma:         "42e56547864ebc7067098b1e98b6f95c23355371790848a051a5384b7ede52cd"
    sha256 cellar: :any,                 ventura:        "e3548def42c56e802784a9482c73a748c420130bc05043848f88fda2b7111132"
    sha256 cellar: :any,                 monterey:       "30e8901c3a629b1afecd15009c8ff162f60451d2f33e81486cf74081f12f344c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8752164babfa0db3cb1e9051f3eab3ae6b61e43f615bb6871e66d210f424d7"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
  depends_on "six" => :build
  depends_on "pkg-config" => :test
  depends_on "capnp"

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
