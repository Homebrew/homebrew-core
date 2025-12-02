class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "d00dc47df7163c2bacd70f090441e8fad96234f0e3b96c54ee9091a49e627adb"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1543302ea068c0a2c81aa893fa96e827c06b2ed436ece69b92282e35ea7907d0"
    sha256 cellar: :any,                 arm64_sequoia: "6df12b8a8057058470fdf155133b3a021ab096d2d0def41d547fe11199e7eca3"
    sha256 cellar: :any,                 arm64_sonoma:  "2a6d58b98055e63541c81c4c9f830cbabb6fa09ff0d248fe3ce0580ff133540a"
    sha256 cellar: :any,                 tahoe:         "a56b0aeaad4870083f19dc17376f165b35c6f5111433b12e67cd1b20c785b41f"
    sha256 cellar: :any,                 sequoia:       "c443448c8edf65b6a6dcb88f03be28865a310c2845bbf7d59a1d4a1f3f1ae4a9"
    sha256 cellar: :any,                 sonoma:        "dcfafdee5d630e07555c642f28bf7d4ae2ad70692a9615eda4128baeb315567c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e9bef63025272a7ee09eb6fc9af9a58ad3fb622ac01d47366fe734c366a8b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "721d3f4c30d2ac9b6c27d369f41c066c5434feae2ad7bc42d49c348d17cd4804"
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
