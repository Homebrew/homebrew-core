class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.9.tar.gz"
  sha256 "f2e31371f9cf1b36cb4f57b23fd6eb849adc7d935dcf49f3c905aa5136382c2f"
  head "https://github.com/YosysHQ/yosys.git"

  bottle do
    sha256 "f08231e871b392051da5e08d777c2ab06017718918825155ede2599512f63044" => :mojave
    sha256 "7affc089d87cd4df5bc4d482cf445572b8fbb056eb7629ea8a7439b972ccb085" => :high_sierra
    sha256 "910e842bc8d1337b978ea0f7b93f693a17ec12f93a1a3bac6a53306087d5c8b6" => :sierra
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
