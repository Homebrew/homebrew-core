class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.14.tar.gz"
  sha256 "d8215b571a581be1332d2106f8036fcb03d12a70bae01e20f424976d275432bc"
  license "Zlib"

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/SDL2[._-]v?(\d+(?:\.\d+)*)/i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "bdf2c30a7267e33a214a0170b6639a31f6a86b5ae524ebfa9dcb06c54d2c1514" => :big_sur
    sha256 "872de41df14b0ee308044df109749b048b3fa22a039b1c47fe1b43bbb681d20b" => :arm64_big_sur
    sha256 "d02d45d59eabad3ed6ffdd780e44f798f35748a1080ce48ded17934bd0db2e05" => :catalina
    sha256 "6ff1b92dc1515a631549343ea7f52ddc108e5a08cd5f462f2ba0a31a04fd0d13" => :mojave
  end

  head do
    url "https://hg.libsdl.org/SDL", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    # we have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --without-x --enable-hidapi]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
