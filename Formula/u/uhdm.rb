class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.84.tar.gz"
  sha256 "bb2acbdd294dd05660c78ba34704440032935b8bc77cae352c853533b5a7c583"
  license "Apache-2.0"
  revision 1
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "670acc688d73fba8ac6565fca378f022b5d1f6f37699df288ee5e9dc38b8b656"
    sha256 cellar: :any,                 arm64_sonoma:  "255be8c70c052277b40458bbb152fd969c46ccf12ab9108e6f1dfad702d1ce37"
    sha256 cellar: :any,                 arm64_ventura: "4b261cec78b1348d493ea3147509161746b1198fde4c6a5251fa346b0e3d13b5"
    sha256 cellar: :any,                 sonoma:        "73ea9f87f818f189e140a0871d93a130f038d5c082465209c025ee4eb65517b6"
    sha256 cellar: :any,                 ventura:       "5cbdabfcb3ea0e53e3b1682f544c1aff82613b71ce89d047fc393638ffd3a5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9f3fc34c3cf05f8674c551793cdf1492f151f93496016eb7a2e6ee8fe76726d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84b61a7b60b854c05302fcac7cf6a6fecdf54682a879f062ff31fc4bbdbad012"
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
