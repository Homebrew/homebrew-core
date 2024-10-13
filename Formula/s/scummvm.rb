class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  stable do
    url "https://downloads.scummvm.org/frs/scummvm/2.8.1/scummvm-2.8.1.tar.xz"
    sha256 "7e97f4a13d22d570b70c9b357c941999be71deb9186039c87d82bbd9c20727b7"

    # Backport fix for freetype 2.13.3
    patch do
      url "https://github.com/scummvm/scummvm/commit/65977961b20ba97b1213b5267da0cb1efb49063b.patch?full_index=1"
      sha256 "2eefadef10af4729f6912ce281daafe12eabce52d7f8b62fc23de30ee768eb9b"
    end
  end

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "cfd21e92209419315ef99bfc79a8f2be58a1db981dc5dc52f8e8a68a13034ba1"
    sha256 arm64_sonoma:   "1f34c784f24a09d9c1e2a33cbbf18dedeff09e0bafd58d01716a4096b9c48b14"
    sha256 arm64_ventura:  "8baab614c52c858f80f44ba0223f43c92bc3b5ed8997c32362943a7d6cb03d35"
    sha256 arm64_monterey: "e9709285ca539ccb4afa33b6de2ff5280a59d7ed36bc64f9653aa944d2006e70"
    sha256 sonoma:         "9bfa4e1c9aa80ad21fed3241d97a933d537b6a5868afb3d955a1e89a563db033"
    sha256 ventura:        "cd6d4c32e81f40a9c32713ce9b3a936901bfbd3d382ebd33b589bb2f5fc4d57a"
    sha256 monterey:       "00e9e4d8ceecdbfb5a2b882019b82fec235ff7c36e94d98974e968c59ca10757"
    sha256 x86_64_linux:   "33ad7a863a3c60bb98e020f9bb38dabff301759ae3f7add00b4a05d95d88a1a0"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libmikmod"
  depends_on "libmpeg2"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    rm_r(share/"pixmaps")
    rm_r(share/"icons")
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end
