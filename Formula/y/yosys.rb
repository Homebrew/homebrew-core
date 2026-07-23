class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.67/yosys.tar.gz"
  sha256 "608d758a6efc73c9f866b0a822aa2f788c2889fcb70dcdcc0e758009465049f6"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d7a0710f79770e9c08e0387f5853860da0031c65528ed95df8e2c30e91fb456a"
    sha256 cellar: :any, arm64_sequoia: "0d50954d12cb5376fefe75c6e58e40829d77eba4219d2d2f8f7d3c4294c5ac6b"
    sha256 cellar: :any, arm64_sonoma:  "b1b35adb346d3d04f5ffe4ef1582f83705a1d532323278cc4bf388b101345118"
    sha256 cellar: :any, sonoma:        "cba22afdd873a4a4950622bf72dd7c8f82f90bd3f22e7e7e05877553c2958d28"
    sha256 cellar: :any, arm64_linux:   "4d0182cdf0e971b8cceca5b1e49f4f0a768e539e8715db2e36f400d69aa412c8"
    sha256 cellar: :any, x86_64_linux:  "a5951127d5c9b2aa97b7cbdd3f02a351851ba70ebf19762171b4c50705fbeb10"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "fmt"
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "tomlplusplus"

  uses_from_macos "libffi"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Let bundled fmt/tomlplusplus/boost_regex use system libraries when available
  patch do
    url "https://github.com/YosysHQ/yosys/commit/cf773aaa13364edc53a14aed1fee9a22112e9fec.patch?full_index=1"
    sha256 "345977646fcffe3cccad0a70fd07b45982053fec3f256f2d6e181b40ae13dbc7"
    type :unofficial
    resolves "https://github.com/YosysHQ/yosys/pull/6031"
  end

  def install
    # Avoid shim reference
    inreplace ["cmake/YosysVersion.cmake", "cmake/YosysConfigScript.cmake"],
              "${CMAKE_CXX_COMPILER}", ENV.cxx

    args = %w[
      -DYOSYS_WITHOUT_EDITLINE=ON
      -DYOSYS_WITHOUT_SLANG=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
