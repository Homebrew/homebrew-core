class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2021.3.tar.gz"
  sha256 "b6b4194121ee8084c62b20f8d574c32f766e4e9237dfe60b0658b316d19c6b13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fde163985e77436a561a3d7bc519293312ff2182de12edeecfa8a2c5ede11d6d"
    sha256 cellar: :any,                 big_sur:       "5771922301fbbececf2ea975947bb37fb755365f28b5d9877b67e6a935fd2b29"
    sha256 cellar: :any,                 catalina:      "d1dd5215d2f0001194c143f3f7b77d68a40ecab0d3a9680b0ac9b011226ca22c"
    sha256 cellar: :any,                 mojave:        "5319261202baf28c050bed985b4a012430a9568ae0f0ff968797941c299f0557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e9d50009fda4cb51207189872dfbd6dfccfab91e8d6e43d588d3897f61a0660"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "f8e389f3acdc2517562924239e2a188037393683"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "2ec8f8738118cc483b67c04a759fee53496c5659"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "e71feddb3f17c5586ff7f4cfb5ed1258b800574b"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_SHARED_LIBS=ON",
                            "-DSPIRV_SKIP_TESTS=ON",
                            "-DSPIRV_TOOLS_BUILD_STATIC=OFF"
      system "make", "install"
    end

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"

    args = "-lc++"

    on_linux do
      args = ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end
