class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "http://www.scummvm.org/"
  url "http://www.scummvm.org/frs/scummvm-tools/1.9.0/scummvm-tools-1.9.0.tar.xz"
  sha256 "b7ab2e03c5a0efb71bb0c84434aa481331739b2b8759361d467e076b8410f938"
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
    sha256 "9457b10e98204d853a80391ce28103d5385c18928f6fa3b67581f40605c61d80" => :sierra
    sha256 "9cbf78a1c306ef399126c399bca23c75570f8edfba2cb7c8da4dcda4c46c2627" => :el_capitan
    sha256 "799cf02d89a726ff7d42bcf9777ad11eaf98e12ba13bc6581e69b5bb99da9f33" => :yosemite
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
