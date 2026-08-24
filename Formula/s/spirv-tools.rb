class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.357.0.tar.gz"
  sha256 "d31e7109b6ef3559067e53e520870eafed7c9534d00db9728814b6df03fa4a5e"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a00b484190a546a8b5284da248deebb92ab6fac0688f3f3ba1b334fe8f127f74"
    sha256 cellar: :any, arm64_sequoia: "b7b146efc7de27c2f4bae1abe2c8f010502345f7012d2850f1259a71a380789c"
    sha256 cellar: :any, arm64_sonoma:  "a9f495c0fe5ada11a30bf0dd5b25445d4311761296175668e8cd120d4397dbd1"
    sha256 cellar: :any, tahoe:         "32bf9b87fb105c18498e0884e72a93b61a77a64fb4fc6e74d2ce7189221576e3"
    sha256 cellar: :any, sequoia:       "1b24b6eb9d0a13ffe266f4e690b33abee1d83eb649636b7ed180fba023d3af8f"
    sha256 cellar: :any, sonoma:        "6aaa2f3af843c0cc540ec797ea023da04105278f680bbec07ed0597b980a54e8"
    sha256 cellar: :any, arm64_linux:   "82567fecec69427f8955336904bc0b68b1811fd418ba8c276c004bd6ca8cebc7"
    sha256 cellar: :any, x86_64_linux:  "97e24d85956d591dfbf4cc9a6c8de703593dfff3bbb220359a5090c23ec0bef0"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers" => :build

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV-Headers_SOURCE_DIR=#{formula_opt_prefix("spirv-headers")}",
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
