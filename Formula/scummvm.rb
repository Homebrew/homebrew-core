class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/2.0.0/scummvm-2.0.0.tar.xz"
  sha256 "9784418d555ba75822d229514a05cf226b8ce1a751eec425432e6b7e128fca60"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "2248018926e2f50dcb66d7162215362ced94733b4ed88bce08a9ca4310223c3c" => :mojave
    sha256 "1de93783f408c2cfc634d8f13c8cb7db1e2544d021f15e0484e64a92af2ed3db" => :high_sierra
    sha256 "bd2da4d91eb4e0f8fcf69ad9383a89979c73e539f1b1a5df8d7d99dc01fb67c5" => :sierra
    sha256 "26dce34185c67fe8034effb99e248b9b68344063194ccb20c8c166b2f6c58dfb" => :el_capitan
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
