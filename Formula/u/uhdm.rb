class Uhdm < Formula
  include Language::Python::Virtualenv

  desc "Universal Hardware Data Model, modeling of the SystemVerilog Object Model"
  homepage "https://github.com/chipsalliance/UHDM"
  url "https://github.com/chipsalliance/UHDM/archive/refs/tags/v1.74.tar.gz"
  sha256 "92cefa641610457772c91d45864e3f4d65bfa0bf300886dc3067a561358a8eed"
  license "Apache-2.0"
  head "https://github.com/chipsalliance/UHDM.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "603fcfd30bdb29e75ded1156f152364ffea6df466afece5c49b294cefe8675ae"
    sha256 cellar: :any,                 arm64_monterey: "7fd82d12d05fae2cfea5dff5b0fb81f0019efbb680b066eacf10126219cb3634"
    sha256 cellar: :any,                 arm64_big_sur:  "791a84a9622356e0575021473756bd3eb1deb14b1c33304227e4a9b575c63904"
    sha256 cellar: :any,                 ventura:        "5b1146c774ede11adc43259efe9846f477faa80fe7b0cd5ec6132b97038527e1"
    sha256 cellar: :any,                 monterey:       "430e489576fa08f114332a90be1c09bc39031e7dc5908637f309ebea2fc69096"
    sha256 cellar: :any,                 big_sur:        "96f6edbfb623b7b03bcbc8e9477d29b0b542a5ebf97f876d9104952ca1e5dc5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb22de79f1b6978db5017ff3f2b9efaed408b86cd61d2e5cdcce0f49a1517f5"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "six" => :build
  depends_on "pkg-config" => :test
  depends_on "capnp"

  resource "orderedmultidict" do
    url "https://files.pythonhosted.org/packages/53/4e/3823a27d764bb8388711f4cb6f24e58453e92d6928f4163fdb01e3a3789f/orderedmultidict-1.0.1.tar.gz"
    sha256 "04070bbb5e87291cc9bfa51df413677faf2141c73c61d2a5f7b26bea3cd882ad"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.11")
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

    # moving to share
    # https://github.com/chipsalliance/UHDM/pull/1013
    rm lib/"UHDM.capnp"
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
