class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2020.6.tar.gz"
  sha256 "de2392682df8def7ac666a2a320cd475751badf4790b01c7391b7644ecb550a3"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "be3e8a4a7679c08b9072bfa76ffb729f28c6ac741fa58d44066d7291339a0088" => :big_sur
    sha256 "b150e16e5d4d40f29dfd739bf297cebfa232d3ae267fb7965d4151a8ace43ec4" => :catalina
    sha256 "f5ddf173300822bf7f7f0b42bafdf1d242b1de1b63a565d02e0084f7b4107d36" => :mojave
    sha256 "4bcbda12ffa24d5bcc19271cc318a035130d4f168145397704d0ef98fe1adda5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "ca11026a032ce2a3de4b3c389ee53d2bdc8794d6"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "2ec8f8738118cc483b67c04a759fee53496c5659"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "f027d53ded7e230e008d37c8b47ede7cd308e19d"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DSPIRV_SKIP_TESTS=ON",
                            "-DEFFCEE_BUILD_TESTING=OFF"
      system "make", "install"
    end

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"
    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", "-lc++"
    system "./test"
  end
end
