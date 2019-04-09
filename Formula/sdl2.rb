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
    sha256 "73dc083fe09bef54cdd08d6e1d86fba67172bc7bda4886e410d3e72fe5ab1c32" => :mojave
    sha256 "eb6b0eb77c69f111c67f48962699e5b237eab26c3a49f8f46bf59bfa241839ab" => :high_sierra
    sha256 "0d441c1d1e113950119870f499995a8daf426b6be8a3ff29f4300d2bfb47076f" => :sierra
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
