class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.32.4/SDL2-2.32.4.tar.gz"
  sha256 "f15b478253e1ff6dac62257ded225ff4e7d0c5230204ac3450f1144ee806f934"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7aa4224b56ceddc46eedc4cf805ac236fe2d5a5b5b33a93a69b5471dfa43d691"
    sha256 cellar: :any,                 arm64_sonoma:  "b61af37727abc55b55dbe2baf1b8ec02c3cd85e66afa98f6db440343a21cd4b0"
    sha256 cellar: :any,                 arm64_ventura: "aa9658eed3e2e5634d2ce24f544684d13b8059aa2c5bd99a9f02f043c96ea6c4"
    sha256 cellar: :any,                 sonoma:        "f7e2133875018fdfa8221bc9084b3043b4149cdae850a1c731409f6cf8f3f5bb"
    sha256 cellar: :any,                 ventura:       "8ad8dff987ec56ff7633cb1dccd8c57fecd1e2450ea01ba711f4f49f24d629ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bccbecc2057a6d8cddc312150a6988b980fb7579f74b4f7cc233fa2909b3b8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68c49d05f60cafbe2c9f4a75901a5c2513c43327f0a3b8921ec44008249b66e2"
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
