class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.9.tar.gz"
  sha256 "255186dc676ecd0c1dbf10ec8a2cc5d6869b5079d8a38194c2aecdff54b324b1"

  bottle do
    cellar :any
    sha256 "4bb274c9c192aa099d4f9ce7794e25b59161aeb58b72206e2934d4bfb6ac7e32" => :mojave
    sha256 "c99606f305a37478afffdc9a6f68c712d5271f07381e2dfb110e6f44fefe68ab" => :high_sierra
    sha256 "3d2472c82b4a210a712178dd8f9137d2e73241a26f163248eba09cad62f2bf56" => :sierra
  end

  head do
    url "https://hg.libsdl.org/SDL", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Upstream commit to fix issue with library version numbers
  # https://hg.libsdl.org/SDL/rev/d274fa9731b1
  patch do
    url "https://hg.libsdl.org/SDL/raw-diff/d274fa9731b1/build-scripts/ltmain.sh"
    sha256 "9845d8f947dd5b809c1dedba711c878cf2a4644a570cd21a81b574e609eb986b"
  end

  # https://github.com/mistydemeo/tigerbrew/issues/361
  if MacOS.version <= :snow_leopard
    patch do
      url "https://gist.githubusercontent.com/miniupnp/26d6e967570e5729a757/raw/1a86f3cdfadbd9b74172716abd26114d9cb115d5/SDL2-2.0.3_OSX_104.patch"
      sha256 "4d01f05f02568e565978308e42e98b4da2b62b1451f71c29d24e11202498837e"
    end
  end

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head? || build.devel?

    args = %W[--prefix=#{prefix} --without-x]

    # LLVM-based compilers choke on the assembly code packaged with SDL.
    if ENV.compiler == :clang && DevelopmentTools.clang_build_version < 421
      args << "--disable-assembly"
    end
    args << "--disable-haptic" << "--disable-joystick" if MacOS.version <= :snow_leopard

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
