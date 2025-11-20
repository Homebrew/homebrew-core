class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.32.10/SDL2-2.32.10.tar.gz"
  sha256 "5f5993c530f084535c65a6879e9b26ad441169b3e25d789d83287040a9ca5165"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d023e694d63e6d5adc1acb6110fc57e31fcd1cbcec974f51f4993e108ddc4f80"
    sha256 cellar: :any,                 arm64_sequoia: "702b9e09ac8a7cc8a99ab4e9298803bbfcd3179d7b029883fe760ceecf98e526"
    sha256 cellar: :any,                 arm64_sonoma:  "5dc1f9fda53f4189beea57bfeffb205012c72e223cef488f6c3fa6c7dd0ba40e"
    sha256 cellar: :any,                 arm64_ventura: "865d7b096886d5d80425a1cfd7a3386056db8b8d4d7191ffc06f140b2785aa5e"
    sha256 cellar: :any,                 sonoma:        "df04d6460b7ab3baefc14201d886a0e27e694a5ba11b075c5725402d8b143c15"
    sha256 cellar: :any,                 ventura:       "5bb2ddf9a2403f7b76f9db786c017f9e38325ce1b6203b4b917afb23525ee04e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e050a5f8c665edb6a5afef282d9508355095a579484e92ea5dc69b26c5acc16c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98bc16de311c00276a48d4424b86ddc32fa9f65438edfa0fe048cff9e15d2db"
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
