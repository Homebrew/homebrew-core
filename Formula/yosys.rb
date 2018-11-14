class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/cliffordwolf/yosys/archive/yosys-0.8.tar.gz"
  sha256 "07760fe732003585b26d97f9e02bcddf242ff7fc33dbd415446ac7c70e85c66f"

  bottle do
    sha256 "cf9c8664f16f9dcca779337065b667d1bac5a8787810a3bb354c9fe477ed9629" => :mojave
    sha256 "e1b4bf8b03f9afdb4963d860c1a6c4f696373b707aea6ee4eec28399f3b51b1d" => :high_sierra
    sha256 "55acf76216af2d941ce39e3a66dbad97a378fba28a55c1818e0ac49867aa2fa8" => :sierra
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
