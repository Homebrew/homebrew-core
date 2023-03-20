class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2023.1.tar.gz"
  sha256 "f3d8245aeb89f098c01dddaa566f9c0f2aab4a3d62a9020afaeb676b5e7e64d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "916d8dad376b992a828381434fa0ddd15b3a9ffc400faad24ee94c39d120f5f6"
    sha256 cellar: :any,                 arm64_monterey: "1a0442fe06ce023a264efa6130737aaeb8c85f7494ffb075e0f2ad0eb2d658d2"
    sha256 cellar: :any,                 arm64_big_sur:  "f2615f4bdc222feba22ede47a25e982dbf67772563d04ed35a9e04a147a749cf"
    sha256 cellar: :any,                 ventura:        "aee6553cf98dccdca9e6a44c429fe898fe75439210c8a246e482bd2a582aae44"
    sha256 cellar: :any,                 monterey:       "7ec4ade9e0d39b04c0bfa3603aa711aee8d3b29efbcd3b4e8d87b09eeb676085"
    sha256 cellar: :any,                 big_sur:        "e1ca07f84e15f2064973039018353e9ebd7b3bfd14b97bec653a47173a80e463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d241e865c471ada045b338a345d4a62bebed2e9b263859d5cf4a03de3a5bf7ae"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "shaderc", because: "both install `spirv-*` binaries"

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "954656f47fe8fb505d4818da1e128417a79ea500"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "c7b4db79f340f7a9981e8a484f6d5785e24242d1"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "d13b52222c39a7e9a401b44646f0ca3a640fbd47"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_INSTALL_RPATH=#{rpath}",
                            "-DBUILD_SHARED_LIBS=ON",
                            "-DSPIRV_SKIP_TESTS=ON",
                            "-DSPIRV_TOOLS_BUILD_STATIC=OFF"
      system "make", "install"
    end

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"

    args = if OS.mac?
      ["-lc++"]
    else
      ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end
