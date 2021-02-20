class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2020.7.tar.gz"
  sha256 "c06eed1c7a1018b232768481184b5ae4d91d614d7bd7358dc2fe306bd0a39c6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "298a193c4afa67d0205bcda76cc8ec2cdbc4c501b426da048ddedd39293db17a"
    sha256 cellar: :any, big_sur:       "f0d685a0636f3fdc829b3bfd050b9307eaec55d3c14cc268597a5b6337878b00"
    sha256 cellar: :any, catalina:      "862c589b37c0e016504a21f15db961537fda9233d646181154addd96495da1b5"
    sha256 cellar: :any, mojave:        "8ba12af92ba9c44685ee2bed8f10ffa2890b0a991d7298659b1188351fc53521"
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
        revision: "faa570afbc91ac73d594d787486bcf8f2df1ace0"
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
