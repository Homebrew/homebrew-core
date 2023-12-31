class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.28.5/SDL2-2.28.5.tar.gz"
  sha256 "332cb37d0be20cb9541739c61f79bae5a477427d79ae85e352089afdaf6666e4"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "cb7dda69b667b3ab46b06d0258709829d13f8958a7ad357c862c24195c947b21"
    sha256 cellar: :any,                 arm64_ventura:  "37643f9e5212d7a7658d65f16f9bac115a47ab2322a67a24b49a1e6ac81e6e52"
    sha256 cellar: :any,                 arm64_monterey: "18ebbddcaa4e68845f73bd1e7ed69cf1bbc63b333203356ef91ec8a264c12e8a"
    sha256 cellar: :any,                 sonoma:         "7186bc4ca35a3a00b3057039f5cad8afdbb7536c2a111a3184a35b1522f972e4"
    sha256 cellar: :any,                 ventura:        "621e521f45d77096ebcfeabb29fbed53c5f6a495b402338b4f3fa8e401702175"
    sha256 cellar: :any,                 monterey:       "b4dc6a975c41ea2f97b91f38d8ee2d2657a96b36d1e40560bd63779ad4d31230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8fc38d9916e89c60263e8fd856c647b781ce126efb3c36d37ad4cb711151c49"
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
