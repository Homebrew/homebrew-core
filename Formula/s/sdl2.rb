class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.30.1/SDL2-2.30.1.tar.gz"
  sha256 "01215ffbc8cfc4ad165ba7573750f15ddda1f971d5a66e9dcaffd37c587f473a"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad1ffd46cba06c78f3c86bc14204b5b59fa398efaff22b607fe120fc38f58ca4"
    sha256 cellar: :any,                 arm64_ventura:  "6a76804280556b101c42ddbdb40d32cc615c1c95c7de1f8159741cb3eedd0511"
    sha256 cellar: :any,                 arm64_monterey: "e546a0b6fe940072b0a157902a1f7ac16b3f532bb0e58c816c0c58fa7dedae82"
    sha256 cellar: :any,                 sonoma:         "d936a473c17225d608e1921b844138570f255f944872b96b6681606762db7139"
    sha256 cellar: :any,                 ventura:        "24d2c375fa1e365fdf649c0d8cb0670391629625f98c4c73a37d352025289cf1"
    sha256 cellar: :any,                 monterey:       "b73113c66e97db1a3ee04fc1d85d0c830270654ca0c8996b83bc0f6fcb5a41b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb38b26116a723d5e9f4ab8bd22bce67a06bbd818553c315bf0650a5140faf7"
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
