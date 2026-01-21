class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.335.0.tar.gz"
  sha256 "8b3d5637061b52675e506ffa1100740031e38bdd96b8177978acfd898a705da2"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e6b3dbbbb8c97eec8e56dc385a9f517d61399231aee129514e17b4970ec9742"
    sha256 cellar: :any,                 arm64_sequoia: "3a72398c4f5c8f81a12a49de5ee142d1aec2b70307090f2b069bb82c49ff84f0"
    sha256 cellar: :any,                 arm64_sonoma:  "8ed0f335c7d8ee0eba7d0d5135443903bef37cff5b88cf56137e0f9c758b63c4"
    sha256 cellar: :any,                 tahoe:         "f22ca9d720e21acf3de0a062fb93dc5630862d1633cf572c5e000abd7a5ed4fc"
    sha256 cellar: :any,                 sequoia:       "3486bfe00dfeae025ffd9cfd1fe9cc9366ff881b40676ece765aae2b93782303"
    sha256 cellar: :any,                 sonoma:        "d14897eb4e6096a031efba9f5639e3f57566a0aee67c60687aaa373960e12bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eba3c6d769f5f85b38823aadea18549c85bd20bcedd5262bc65dfc15f706811d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69d523d48f0b380826b7f8139c04bfe35d814476a2d0f5a5a89de49942803e0"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers" => :build

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV-Headers_SOURCE_DIR=#{Formula["spirv-headers"].opt_prefix}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples/main.cpp", "test.cpp"

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
