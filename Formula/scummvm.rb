class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/2.1.2/scummvm-2.1.2.tar.xz"
  sha256 "c4c16c9b8650c3d512b7254551bbab0d47cd3ef4eac6983ab6d882e76cf88eb0"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "1766f48033c6e9e7623651f41dc5a90ca1dc66ad45b002c35d9e509ef094102f" => :catalina
    sha256 "3ebe35adc3b622ab979c9fc57d82ca1706803df8ee658cfc478dc9f4079a0f67" => :mojave
    sha256 "c1fe0968af5a27e3dffdbf7829e953c1fc3f677c01b324d48db5436177cb0f5d" => :high_sierra
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
    url "https://sources.debian.org/data/main/s/scummvm/2.1.1+dfsg1-1/debian/patches/git_fluidsynth_update.patch"
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
