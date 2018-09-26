class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.8.tar.gz"
  sha256 "edc77c57308661d576e843344d8638e025a7818bff73f8fbfab09c3c5fd092ec"

  bottle do
    cellar :any
    sha256 "12dc3505a304594a615dd79a8f09ff6fb12cac2e83b26062ad5264f6dcda28e8" => :mojave
    sha256 "25cc31a9680beb16321613f740fee7fdd862489948a5280e4a5f94b8ed291dd6" => :high_sierra
    sha256 "81ae8deb6918e241fc0c3c47c11b1e5041deb297e9010f87e1a1584fcf2c17e8" => :sierra
    sha256 "d1cf341785b66ce316564564abe44d7e6e1d1d6e16b26dc9b1e307c68f0bd22d" => :el_capitan
  end

  head do
    url "https://hg.libsdl.org/SDL", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
