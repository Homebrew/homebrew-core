class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  revision 1

  stable do
    url "https://libsdl.org/release/SDL2-2.0.9.tar.gz"
    sha256 "255186dc676ecd0c1dbf10ec8a2cc5d6869b5079d8a38194c2aecdff54b324b1"

    # Fixes an issue where some software is locked to
    # ~50% the intended framerate.
    # Patch should be in 2.0.10.
    # https://github.com/Homebrew/homebrew-core/issues/36564
    # https://bugzilla.libsdl.org/show_bug.cgi?id=4481
    patch do
      url "https://hg.libsdl.org/SDL/raw-rev/dcb6c57df2fc"
      sha256 "bf8c15a876ea1b833a9c8a36d4ededc2eabe8371a1c857caaf35cdbdc400bc79"
    end
  end

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

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head? || build.devel?

    args = %W[--prefix=#{prefix} --without-x]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
