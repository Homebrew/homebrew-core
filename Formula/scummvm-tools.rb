class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.0.0/scummvm-tools-2.0.0.tar.xz"
  sha256 "c2042ccdc6faaf745552bac2c00f213da382a7e382baa96343e508fced4451b3"
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
    sha256 "36ea5fcfab0c2b6dc6424d8c4a0033972789c87f5c97da67c38fb092d02a189d" => :high_sierra
    sha256 "5f8a8406cb7e147e6685b071b8a191a23e41d7b92e3baae224aadcec0a3b2f14" => :sierra
    sha256 "c080f7bee0508417bdf00197bfb85d5efb57b0db227116c953da214e6d018acd" => :el_capitan
    sha256 "b3f53f0d44c12cb87f00de13bdbff91b4e3ea5c7f7049fa61a5abe6e3cf4f287" => :yosemite
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxmac" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/scummvm-tools-cli", "--list"
  end
end
