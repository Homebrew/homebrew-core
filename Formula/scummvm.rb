class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/2.1.0/scummvm-2.1.0.tar.xz"
  sha256 "6b50c6596a1536b52865f556dc05ded20f86b6ffabe4bccbd746b5587b15f727"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "213a7b49024659878d44c874d3d493f348bd7042a63940d62bfa54aed3541224" => :catalina
    sha256 "a9e8736f6b93bbf3c6c165831a58d944f488a0c4287858b4fbd39f635941f703" => :mojave
    sha256 "1bcbb3168dbe936067d015f60fa19cd5dca0892e10c25ff18f86e49c0a268129" => :high_sierra
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    system "#{bin}/scummvm", "-v"
  end
end
