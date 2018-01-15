class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/2.0.0/scummvm-2.0.0.tar.xz"
  sha256 "9784418d555ba75822d229514a05cf226b8ce1a751eec425432e6b7e128fca60"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "3510d4d1f8ad96cb4d21ee6b1a584c3657ba974a5b896d27fe2025d3cac54a3a" => :high_sierra
    sha256 "eb9cad5628c6a13be6dadeedfe15d05c8ec18e5ecc5d6e725916c103a45f3200" => :sierra
    sha256 "3e691aba43ac7f9bb56eff09d0b8c1d6a9e5843d30d3c7d209135ca1965d5169" => :el_capitan
    sha256 "03a4c813c8a6ab9dd1f08f8efaf5d6972c27fffad4312070a7f22f04845de257" => :yosemite
  end

  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-release"
    system "make"
    system "make", "install"
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    system "#{bin}/scummvm", "-v"
  end
end
