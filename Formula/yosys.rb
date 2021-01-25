class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.9.tar.gz"
  sha256 "f2e31371f9cf1b36cb4f57b23fd6eb849adc7d935dcf49f3c905aa5136382c2f"
  license "ISC"
  revision 3
  head "https://github.com/YosysHQ/yosys.git"

  bottle do
    sha256 "6ecd94923b663972312bf1c6e50ddfef817ffb7257118e6d1f0bd6836d3057a5" => :big_sur
    sha256 "e2df722fe6fd54e15f7683bc49ec6f77895fd97687d38743507deb88c091c982" => :arm64_big_sur
    sha256 "30136c3fe55e45d36aa1587a48bc69030930563b2fb0f386ce122d79a4dbba87" => :catalina
    sha256 "6298e8bfeff2fa1f4de993642b43afeacb6c98a3f262c256d495339ee141dff4" => :mojave
    sha256 "a8807693a57f363e1a2d95034feffa3ab14c3645910f154d128990ae0484439e" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python@3.9"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
