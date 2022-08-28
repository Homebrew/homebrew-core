class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.20.tar.gz"
  sha256 "ee261487badf1b554616d555da8496a7c84ef21ae66a979ddd946b6949a780a4"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "b583c15eef8777a14b50c9f526541aa34801d04989d691c5d5767d0003ec4a7c"
    sha256 arm64_big_sur:  "5e1321a1ad612f5d3151ed69d39b5b518ed819f60f24fb9ea295fa60e13c23ec"
    sha256 monterey:       "ac5dbd2799ff87ca76386df9c7085836d894cf00f43638c681199d4a4621a936"
    sha256 big_sur:        "fa0d6d16e84586963cfa00b33b78aa6ac9e1b47b03dfe67d5c7cbeed07537834"
    sha256 catalina:       "bab924c22cc75f6a1559423639a3fc3bdfc4d05676209d0a78bde9000d707227"
    sha256 x86_64_linux:   "34f68e6b1d0576dd19616f20bdfff45bf7c3fdcb14c8f455e00334e3dff7e295"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
