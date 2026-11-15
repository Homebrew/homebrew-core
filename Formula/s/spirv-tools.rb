class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.363.0.tar.gz"
  sha256 "e6c83a215538fbfd265ccf398d3877985055df1273dbed73912bd05307664688"
  license "Apache-2.0"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "be9c608d9d4062e661bf54c48df8eefcda66503655a68bcf251621eb4b4592d3"
    sha256 cellar: :any, arm64_tahoe:       "f1b075c2a107e314872144082b0ae49c18c15d7002e818fb60fe62f2d1c72e5a"
    sha256 cellar: :any, arm64_sequoia:     "bb9db0cc79ff0ac541fb4324840527101fb7f57dce9a8c43d92b9252ab12983a"
    sha256 cellar: :any, arm64_linux:       "df8588d02e23b70111c93e2d015eee5fae1b2b0bcb811814871f5ed7532a9cb5"
    sha256 cellar: :any, x86_64_linux:      "bd6916b758897be4fa710c214736c83fc46697ea425fdb118cf597b31c4e2a92"
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
