class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/1.9.0/scummvm-1.9.0.tar.xz"
  sha256 "2417edcb1ad51ca05a817c58aeee610bc6db5442984e8cf28e8a5fd914e8ae05"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "34e01d9f579230ff887a801722d9bd2d4dd4f7245ae5c96ef3d6a0c3a13003bf" => :sierra
    sha256 "300612434290d59de56fde9715ca32ee8b8671d76625c3b79197cf44c81b2201" => :el_capitan
    sha256 "213a1905e6d46cfe685e0cf25f0d7bb164bace5abbaff9497f4c1e40f794240d" => :yosemite
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
