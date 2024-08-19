class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.30.6/SDL2-2.30.6.tar.gz"
  sha256 "c6ef64ca18a19d13df6eb22df9aff19fb0db65610a74cc81dae33a82235cacd4"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c88013f3dacc2dedcc4972954127b1ae90c1216da12a3da273ac1647ebd8da9d"
    sha256 cellar: :any,                 arm64_ventura:  "5545cb8c2fb23ec31a3aab25096ed6652e2a592fbae706945ecc2dcf78b20427"
    sha256 cellar: :any,                 arm64_monterey: "a4def3cb596dd4878c3fdcced7a5f3d9fdd86ad7ca88bbcbbcdae23417e3f41d"
    sha256 cellar: :any,                 sonoma:         "da4958b70565507362306f45f4f06912bca156e2580a2901801f31ac672ebb58"
    sha256 cellar: :any,                 ventura:        "016b466c4d6bd1e5e3e65c05226e796e0a1fe5306e471a53e84a7306fe1f414f"
    sha256 cellar: :any,                 monterey:       "03ddade484d4d97147a51e91ac55b638cd03e1218c8b0f772b315a3ba477f1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b622b02aad9153ec08eaac32f61dab981d5ec6e6d3c57a32ca3c3899dd64580"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "SDL2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "pulseaudio"
    depends_on "xinput"
  end

  def install
    # We have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace "sdl2.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --enable-hidapi]
    args += if OS.mac?
      %w[--without-x]
    else
      %w[
        --disable-rpath
        --enable-pulseaudio
        --enable-pulseaudio-shared
        --enable-video-dummy
        --enable-video-opengl
        --enable-video-opengles
        --enable-video-x11
        --enable-video-x11-scrnsaver
        --enable-video-x11-xcursor
        --enable-video-x11-xinerama
        --enable-video-x11-xinput
        --enable-video-x11-xrandr
        --enable-video-x11-xshape
        --enable-x11-shared
        --with-x
      ]
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
