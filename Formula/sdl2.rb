class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"

  stable do
    url "https://libsdl.org/release/SDL2-2.0.10.tar.gz"
    sha256 "b4656c13a1f0d0023ae2f4a9cf08ec92fffb464e0f24238337784159b8b91d57"
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
