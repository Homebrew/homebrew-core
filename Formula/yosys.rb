class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.15.tar.gz"
  sha256 "a40fcc487d2a31c2abc6f61d39a84e262f2650e40de479542bbde317308c4612"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "989409f9cae4b5495439f49d218e4526f19ca45772fda1be43f2e556514c765f"
    sha256 arm64_big_sur:  "322fbb914f431f060c6ce41ccc0f774e20ef3023f015e0a6ea3db4dc3c5fe104"
    sha256 monterey:       "7d9285e1d2d60e4402d25770790c34b4a8a310de5ec68b3422585993cb977a81"
    sha256 big_sur:        "9c3d7785b8eb27bbd47c5e1b572764126b153c37852f1f1bb81e2299119886bb"
    sha256 catalina:       "6a92aa57290fc972ecf891cf4a2143fd4b40ae9f187540527884d5a188a9cbcf"
    sha256 x86_64_linux:   "be74b58de8675ece8e8c7e58222573aa0e86c7947edb031524a7db99ff5356a2"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python@3.10"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
