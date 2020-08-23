class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.9.tar.gz"
  sha256 "f2e31371f9cf1b36cb4f57b23fd6eb849adc7d935dcf49f3c905aa5136382c2f"
  license "ISC"
  revision 2
  head "https://github.com/YosysHQ/yosys.git"

  bottle do
    sha256 "4fb59d68ecc03d90966b442d32d2107854403a772915f5d6543d3ceab008d7ec" => :catalina
    sha256 "b20a335e6a787663fe6bc35a653f4330532047898dae9b9ddda67c40533143d6" => :mojave
    sha256 "a45b22aa4a58d1aa5757d5b19de374c02a41e7a1ade80d7ce8053537fe8f0829" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python@3.8"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
