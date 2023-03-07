class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-2.26.4/SDL2-2.26.4.tar.gz"
  sha256 "1a0f686498fb768ad9f3f80b39037a7d006eac093aad39cb4ebcc832a8887231"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/release[._-](\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d8c65317a6350dc431c27bfcc1c1a245d2e06a416699787ee0ff1a35bcf75f28"
    sha256 cellar: :any,                 arm64_monterey: "e0096d54920e45c74815e57f4afb18fb57e7cd9f5195ae1ae692a80eca52aad2"
    sha256 cellar: :any,                 arm64_big_sur:  "36f56f638a9251d06595e621a8c5f801bc8f42f61810d0a351caef633835d375"
    sha256 cellar: :any,                 ventura:        "d557661f34c901ed19c7323299c1b23884b9968481cd85e89e939ff6560004b7"
    sha256 cellar: :any,                 monterey:       "f1a036aa68c337758b312df836b2d6f4086ebbdbc735c9ca036fd074d84ff70e"
    sha256 cellar: :any,                 big_sur:        "ab1745bf5cf8d057f5eacdf6307c4c424aff689404b8eb49a1292496eae70b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fecd6e4570d683e1a0f643c17bf18f77d2c09db4cee8d2320bc81fea4d4b326"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "main"

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
    args << if OS.mac?
      "--without-x"
    else
      args << "--with-x"
      args << "--enable-pulseaudio"
      args << "--enable-pulseaudio-shared"
      args << "--enable-video-dummy"
      args << "--enable-video-opengl"
      args << "--enable-video-opengles"
      args << "--enable-video-x11"
      args << "--enable-video-x11-scrnsaver"
      args << "--enable-video-x11-xcursor"
      args << "--enable-video-x11-xinerama"
      args << "--enable-video-x11-xinput"
      args << "--enable-video-x11-xrandr"
      args << "--enable-video-x11-xshape"
      "--enable-x11-shared"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
