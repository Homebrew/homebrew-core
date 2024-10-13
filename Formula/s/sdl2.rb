class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.30.8/SDL2-2.30.8.tar.gz"
  sha256 "380c295ea76b9bd72d90075793971c8bcb232ba0a69a9b14da4ae8f603350058"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aa26b8d44659913c50f5ca0329e8c9b6d9841c219d5a8bb95781d105df77fa77"
    sha256 cellar: :any,                 arm64_sonoma:  "54084f0298c56df9e3d59122e6b5d11222ab3f858040c19125c3bfd030ebddd6"
    sha256 cellar: :any,                 arm64_ventura: "adf8498ea8502f0bccaad4edcb21585fefd11611fafaa452acbf260e55e3b7d7"
    sha256 cellar: :any,                 sonoma:        "c4a378601ee98517260ebd790109f6d5de858928f831b61f11d57c9140cc494a"
    sha256 cellar: :any,                 ventura:       "538d1e6bc19a901d2633285c1a3d80325246978e5ebabef1513aa7be01d3b60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffa7cbb5a2d05303b5514ed72889d532f6b909a9cd6586900e40d9053649cf3a"
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
