class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.32.6/SDL2-2.32.6.tar.gz"
  sha256 "6a7a40d6c2e00016791815e1a9f4042809210bdf10cc78d2c75b45c4f52f93ad"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e32ec4c5b136da53cec56da4320c1710fc52b500cc2c27acd721df2286f94a56"
    sha256 cellar: :any,                 arm64_sonoma:  "d9542355a7bd42eb3f8da6f83ff8f0336c14b0e0f1509d3c1dc2890bfedf2ba3"
    sha256 cellar: :any,                 arm64_ventura: "65911923d130d508cceebff37ecb9393b6bf801c1985953a35227a3e4d2a73ea"
    sha256 cellar: :any,                 sonoma:        "ea5ede3e7d79451dcf2f51a5a07eb9befc588f3b294e16539cb0dc58fc86c24f"
    sha256 cellar: :any,                 ventura:       "72d4b22feb2ee57194e5068d9bf4197885046d64fee1513fea3595d578472e3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd42e7d40cf6c4a0dcb708dabcf998d109dd9aa6c6223ee3587e5cf3770d6c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28b3ab63f8a98a99c230cc86bdfb8bd79c45e02470f18ea2d1b629dfbbc4796"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "SDL2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "mesa" => :build
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "pulseaudio"
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
