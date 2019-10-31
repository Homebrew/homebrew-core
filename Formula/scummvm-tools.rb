class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.1.0/scummvm-tools-2.1.0.tar.xz"
  sha256 "cfc62d285d0e304061db72691cdfb8ce4ead868cffb2658b1f1c81934f404665"
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "773687d73dc41c05ecbf4e9bcce11fd6311d33dc4f62300fb0decf60b49e63b9" => :catalina
    sha256 "16e3730addf75fffc00f8b8edb3a757d37e2d72f8b1c3907ed604ba37ac33bdf" => :mojave
    sha256 "3611bd71703ccd21d188df42448ab64333ab640c54c2352446bd989d2f0ee05a" => :high_sierra
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxmac"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/scummvm-tools-cli", "--list"
  end
end
