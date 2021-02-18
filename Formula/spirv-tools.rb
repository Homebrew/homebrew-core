class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2020.7.tar.gz"
  sha256 "c06eed1c7a1018b232768481184b5ae4d91d614d7bd7358dc2fe306bd0a39c6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "de0e45feb7b2342392980d3d9ee58098615296a0c3f7ff7f02b785fb75fd83ba"
    sha256 cellar: :any, big_sur:       "3e11043908ed15d64d1ae3f8f7938d107e861d6fab9334d8a1738a8faeb99c97"
    sha256 cellar: :any, catalina:      "e51201b6a2af7e6a557c044325b62e2388a08e44a5e4f3e57db544d000860c6d"
    sha256 cellar: :any, mojave:        "c98af1a7354aecc6ff40d15025a83c60ab00e55e73252f9b292cf5c2dad2a420"
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
