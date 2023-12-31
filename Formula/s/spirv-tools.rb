class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  # TODO: Change `-DPYTHON_EXECUTABLE` to `-DPython3_EXECUTABLE` in next release.
  # Ref: https://github.com/KhronosGroup/SPIRV-Tools/commit/a63ac9f73d29cd27cdb6e3388d98d1d934e512bb
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/v2023.2.tar.gz"
  sha256 "7416cc8a98a10c32bacc36a39930b0c5b2a484963df5d68f388ed7ffee1faad3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d22d8c5984c120ada35dcec596e672e5da421c718b964195db049f9ee664efa1"
    sha256 cellar: :any,                 arm64_ventura:  "cd86ec4dadaf9a5df724b5e8e2d0b3434e9dece5f1d0f693171e2b3b49614e31"
    sha256 cellar: :any,                 arm64_monterey: "0637ae77abc11f9ba1677119426ce011fb2e5f6580abcda1d6a6c44503127a69"
    sha256 cellar: :any,                 arm64_big_sur:  "ee408e7ebba7faf63f468dbc17addff81d36a1d056abdacb070c5cf542b178b3"
    sha256 cellar: :any,                 sonoma:         "3320c6c6de9b06ab9b5d6737d25d9b8895f8e4086a95d7bbcccf7e9b3e2ff856"
    sha256 cellar: :any,                 ventura:        "4bc22b444e909a223e10dd78a4769dc610f5d81bc115d3baf4f047c11af9b5c6"
    sha256 cellar: :any,                 monterey:       "058ed9c4f4104887ae3a57458ee1d4e5b13f82b7303f114b4db5920aa25389d8"
    sha256 cellar: :any,                 big_sur:        "b212c0450234482cbf842614c8c8c82cbc2fa00eb6e4f63aae88aeeb47e05841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0f52bb57518a8cd11a581164b724b2585c0b63753aabe2263027c1ab1bde5c"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "1feaf4414eb2b353764d01d88f8aa4bcc67b60db"
  end

  def install
    (buildpath/"external/spirv-headers").install resource("spirv-headers")

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
