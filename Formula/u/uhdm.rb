class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.86.tar.gz"
  sha256 "179203b166be5d1be12b901c69c6a569ebebf4fe47bc674b1268bd9319216fce"
  license "Apache-2.0"
  revision 1
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e96d3e01bd59637e5ce39d819621a107fbe2c49fc71efe6fc2eb8f143d64e26"
    sha256 cellar: :any,                 arm64_sequoia: "a437a6d45b60cddefcb0baa5a2e1659a8744c3f1cdaaf2b2b7c68ec4190b39b3"
    sha256 cellar: :any,                 arm64_sonoma:  "dd0727a5d7ce215b3fff2ad49d24b4eb3ee1e2780af9a612d6dc0f0883cd19b8"
    sha256 cellar: :any,                 sonoma:        "f2d5eea05062e7ac58397defa58b6fc28994aaf894553baca2c71a950d2b14c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e03fce26295440301f53d7d397ca0bd183478a17a27aaefe740d5650517a976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "676e3998e772e2e2a4732326fe2d3c6e895eed009cdd3b8c4612513dc75d3f4a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => :build
  depends_on "pkgconf" => :test
  depends_on "capnp"

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
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
