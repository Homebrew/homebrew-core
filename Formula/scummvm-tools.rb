class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "http://www.scummvm.org/"
  url "http://www.scummvm.org/frs/scummvm-tools/1.9.0/scummvm-tools-1.9.0.tar.xz"
  sha256 "b7ab2e03c5a0efb71bb0c84434aa481331739b2b8759361d467e076b8410f938"
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
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
