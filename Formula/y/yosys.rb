class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.68/yosys.tar.gz"
  sha256 "ad8d2198e1a486e9089cc51a3158ecc764669267879518723fb98acc6fb24787"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9e3261b48e210056dd276dc43bd7b792350cb6e8388b917d9cba8409ea83426"
    sha256 cellar: :any, arm64_sequoia: "4fb467faeafad7bb32a5a8342570d88f3511c34884b5a8736da2367e052ee1d5"
    sha256 cellar: :any, arm64_sonoma:  "52884f2196f48f3e1a66fae5f307ca6d492ac19bdde1005ce7eb556ce6b88c7c"
    sha256 cellar: :any, sonoma:        "1d740875203c981511909cee3b3bc7df3f1f4f7800cc137dc8fbf3fc896b797d"
    sha256 cellar: :any, arm64_linux:   "1b51932942e20f8f9a69f507ee9627ace67dea582cd68d321749ed1da7e3342b"
    sha256 cellar: :any, x86_64_linux:  "8d9061b24f8ccd6d4aadf49732698c7bb51502e9bc2a58cba55521729aff9465"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "fmt" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "tomlplusplus"

  uses_from_macos "libffi"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
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
