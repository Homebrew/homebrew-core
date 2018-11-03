class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/cliffordwolf/yosys/archive/yosys-0.8.tar.gz"
  sha256 "07760fe732003585b26d97f9e02bcddf242ff7fc33dbd415446ac7c70e85c66f"

  bottle do
    sha256 "4c11f31cb7ac87d4eb04594f59bd641b5e53b605c2784fb681d268214690a790" => :mojave
    sha256 "036989ea352804dc6c0b64f621a4501213fe9cb0dafc18fc3b4130ca9dcc59be" => :high_sierra
    sha256 "b89b1b6ebc570c6f5c0508da8d57a0cdcc9995eba5ceefb0e1a0b69460ad47c5" => :sierra
    sha256 "fc4f502421418d92674b9dcb2bfa976ba3fd5622b2bdde486de653caec075eb5" => :el_capitan
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
