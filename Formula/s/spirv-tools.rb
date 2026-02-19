class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.341.0.tar.gz"
  sha256 "15bfb678138cdf9cd1480dfb952547bbb66b763a735b6d5582578572f5c2e6f9"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "987d2e6c830ba5bd78ddb1ed153ff96300ae82f1214541da1b9d396b1ecf5fec"
    sha256 cellar: :any,                 arm64_sequoia: "16870c601269fc1d9019e70216d72100700ac972733ca583a45b8dd4670993b6"
    sha256 cellar: :any,                 arm64_sonoma:  "912dd89569602634bb84ddc2ce48102aafa8567499d30843f2f58b4e3760c86c"
    sha256 cellar: :any,                 tahoe:         "06d3cde68bf229dcbd498dd5b120d073c06e6912ff434d795f46f2a6a5cb91e1"
    sha256 cellar: :any,                 sequoia:       "5664d6e1c63a0e31c0cc712fe06dab8320564534c4713a32cd3b66b04c1a9bc0"
    sha256 cellar: :any,                 sonoma:        "94d00bae6723ad522e0f311591d6e46991b6a4daf81d6d5208763c1b175650b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a43324ad7687e75cb9370a0fca2de2bdb1f2ce659d865dc21c9387e0ea5ede87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc4f609a57841786ca5829e4d41bb1d262035ef9e9239b2717dcb164a97d04e"
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
