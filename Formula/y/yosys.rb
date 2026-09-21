class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.69/yosys.tar.gz"
  sha256 "6dad6412cae417f5a53e2c943c2aee160162cfc1bdd31669230da1b7e3522571"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "233c46e19b8b6a4cb0ec1f5b5f88860f1ae316c91a11b25eaa01c1f486094fd5"
    sha256 cellar: :any, arm64_tahoe:       "03e41ff8da0969905351eb9d4c08d47072ec9465e4388703fe01e2b15d0f93b6"
    sha256 cellar: :any, arm64_sequoia:     "7e556dd0d1ce904c31a67d2ccc81e87dbb75d2d49ce77613440c0aae26c39a66"
    sha256 cellar: :any, arm64_sonoma:      "c760ed86e6f0602c255a4ac93a951d6178db76b171304f1531e8fa68c77dba40"
    sha256 cellar: :any, arm64_linux:       "c1a0fd0aa01db9396f33f32d21eef616eca474e42d972517c027168c2c59dfad"
    sha256 cellar: :any, x86_64_linux:      "e1b53ea580f3986bf4a56927b336262438160294445572939be90242a45ba92f"
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
