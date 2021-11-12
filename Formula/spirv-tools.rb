class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2021.4.tar.gz"
  sha256 "d68de260708dda785d109ff1ceeecde2d2ab71142fa5bf59061bb9f47dd3bb2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6121a7b2c5304c3c88c9626176da97476c603812e16c75242a49de79ee4ee5d8"
    sha256 cellar: :any,                 arm64_big_sur:  "2a6a8dddfea9c6ec0e164d3bc91cd0e07dc2ce64a15f59e6ba2a5f851f34d373"
    sha256 cellar: :any,                 monterey:       "5280741a887af4e753578c35a62dfa0e4e0508d3a4bd1a517b2ab3c77444e3ef"
    sha256 cellar: :any,                 big_sur:        "2c0679ffd907c528e88fea56a965bdba726327c40c5638080b185f79a0eafcb6"
    sha256 cellar: :any,                 catalina:       "fe79aa02c8e46822aa429be46b842dc28876602a772a75c4cce8aa4d2bf8c32f"
    sha256 cellar: :any,                 mojave:         "3075c62d7893812454a63ccf16f88c5db3b26569a33fcfed786c7a0d15c97d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3f62ac74873e3278aded791b108256da0b90b9e1543ec7e5e580261dec5c16c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "4244cd1cb492fa1d10986ec67f862964c073f844"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "ddf5e2bb92957dc8a12c5392f8495333d6844133"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "814e728b30ddd0f4509233099a3ad96fd4318c07"
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
