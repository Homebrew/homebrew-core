class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/releases/download/v0.66/yosys-src.tar.gz"
  sha256 "ba567ea7fbb1287e996aef8f20fe902f6fd408593aa50cfaea8ae0c9015ab872"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "1f455673f860c91a7fe654d49fbd4162a3d4c268974871ae1ae328bf2aefb406"
    sha256 arm64_sequoia: "17485339f20a083a8779c683a7504c69e2fd2a124b862221cea3ddf6499fa85e"
    sha256 arm64_sonoma:  "bbd41f58cedfe9b1088b368526f9c17a58d470fbb33c3a588c45b331ed57d16b"
    sha256 sonoma:        "1830ad3f3aad743221bd70e63a582c106b81fc8d79d4749683d35264118d3280"
    sha256 arm64_linux:   "08d4cc5dd4a7bb5c972b6f5fbc0deec1781cffffa102b81409f248ac388caaaf"
    sha256 x86_64_linux:  "3cd1dbb658d4716b3372d3b5c8374e7a88f88c799a24ba236a8285dec12913c1"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "readline"
  depends_on "tcl-tk"

  uses_from_macos "libffi"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append "LINKFLAGS", "-L#{formula_opt_lib("readline")}"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
