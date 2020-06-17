class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/2.1.2/scummvm-2.1.2.tar.xz"
  sha256 "c4c16c9b8650c3d512b7254551bbab0d47cd3ef4eac6983ab6d882e76cf88eb0"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "d07a54cb41ab353a80387858d68934d48455c6986d94550b0c360c0ce0a8ee86" => :catalina
    sha256 "8cc270e65a0de57d96ba87a974db23dcdac3066d39f80ee691772c8838e0fdb0" => :mojave
    sha256 "601596e0bd89f8f051c63e61e5ea21f76460027545734ea173361b67faa388c7" => :high_sierra
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

  # Support fluid-synth 2.1
  patch do
    url "https://sources.debian.org/data/main/s/scummvm/2.1.2+dfsg1-1/debian/patches/git_fluidsynth_update.patch"
    sha256 "4e03d4b685bf38c2367bb669867175bd4b84039a678613bf6e32a34591b382c6"
  end

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
