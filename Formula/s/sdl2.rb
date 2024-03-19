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
    sha256 cellar: :any,                 arm64_sonoma:   "77cd09b599e3a504fd6923b426474f71fa0875909c7185033b25971d072e82a7"
    sha256 cellar: :any,                 arm64_ventura:  "6e6d6d760dc0a80f9d8bb46686e3c1bb45875f81606a263d04a7e4a01263be98"
    sha256 cellar: :any,                 arm64_monterey: "4425df6b5745c4d8644046fc48eb249ef83a9262e29569e66b3a9fe97f94e143"
    sha256 cellar: :any,                 sonoma:         "fc76391970250f2a74337c1f8a1af06bdfb0b56b2ffb5a6c04169b460eadb358"
    sha256 cellar: :any,                 ventura:        "762a95306c7e962a81f926ce42227e2ba1179a1e4c03eaef1fc4148a800f0123"
    sha256 cellar: :any,                 monterey:       "e27b2d7995065e42d9a3a1ce72393f1413c1d710223e1937fd386227e8502004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b65aad4c0720e6d354ac39626f8014faf5611b387f53a34297187714ce285ad1"
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
