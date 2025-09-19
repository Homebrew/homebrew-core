class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.86.tar.gz"
  sha256 "179203b166be5d1be12b901c69c6a569ebebf4fe47bc674b1268bd9319216fce"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f58b4698cb4b4423a6dedc83e6eb6e1011a34973b6ef2b2c8dba7b6c41d638d"
    sha256 cellar: :any,                 arm64_sequoia: "dc1e8ff01f88dd15f6032e48add9066e59f45c40e5332050e5e2f33c28f4b1e7"
    sha256 cellar: :any,                 arm64_sonoma:  "fcfa5ea123136cebbb5bbb4ccb5f6d5d0f9669245ebf2f9f7aa64ed201a76756"
    sha256 cellar: :any,                 arm64_ventura: "057174dc81499a7ded00eb5115a7568e44693977b0e32049605c7a1c0b642012"
    sha256 cellar: :any,                 sonoma:        "0f5f806d7aae2ebcd1243292447afc68f620a057096cababf91d79416aee3069"
    sha256 cellar: :any,                 ventura:       "71e60562b1f98a50310f1446756277330df092eb0ad09b9f17f0933d4ce0c430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b9408eead8415ec51913bfa1d5f516038e1082be5944952059192ac9e8c75f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf1433b6e7590ab91384724765c4fdc14bfb92f55f3966c40b770acc94b1d24"
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
