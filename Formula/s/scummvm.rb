class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2.8.0/scummvm-2.8.0.tar.xz"
  sha256 "d6e9fbee06a924706635dea225dfd560ff6770f35aa99d59570a3eb883795a72"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ce7088b67e74a857ef8d7752569f60a1411d1bea5077339a821ff6f8f87a4ae6"
    sha256 arm64_ventura:  "c3aa391c44e9b0c4c1443c3dbdb9bf2049537dcb127ca3f2fa546bbafb77f2c9"
    sha256 arm64_monterey: "d56db8b5ea54d9d9e2f292152de94df96164d6ca8fe98f991a27ad19098b2f44"
    sha256 sonoma:         "c5a826a1eda1db58f6088e18810128342e157d9385d80d26c39002d8287154e2"
    sha256 ventura:        "84fb49c0e4acba4878704b148fe3b7263fe7191a7b25bd93b2987e45274589da"
    sha256 monterey:       "cbf5137b5f6b45198db19a26dfbf0cd6957a30b92afd410ebc51f2bcfc4e7ea4"
    sha256 x86_64_linux:   "65be731207ab3c1d76d260572e0cb4a4e077781c607cdd58835a1553ef9c8ba7"
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
    (share/"pixmaps").rmtree
    (share/"icons").rmtree
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end
