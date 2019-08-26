class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.9.tar.gz"
  sha256 "f2e31371f9cf1b36cb4f57b23fd6eb849adc7d935dcf49f3c905aa5136382c2f"
  head "https://github.com/YosysHQ/yosys.git"

  bottle do
    sha256 "e856f06c564a5689254e50572f09d0326c7273221060cce6649b3383a9c3daa2" => :mojave
    sha256 "5cf5f2a4eca32c36fa54c68ff556a6e6ed1737312266d9ae224f7a36f7b28aa7" => :high_sierra
    sha256 "a02bd8ad03be42a98aa8c2935c15b465e9227039d96af638643242e53b462053" => :sierra
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
