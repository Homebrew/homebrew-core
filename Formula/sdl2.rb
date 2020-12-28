class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.14.tar.gz"
  sha256 "d8215b571a581be1332d2106f8036fcb03d12a70bae01e20f424976d275432bc"
  license "Zlib"
  revision 1

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/SDL2[._-]v?(\d+(?:\.\d+)*)/i)
  end

  bottle do
    cellar :any
    sha256 "b21ff3d90bbcc0d3dd2029bac89ce4e279e249ab81744d32fcb7f113d3c4a2eb" => :big_sur
    sha256 "ed28e2f97bb375100413d38ebe49a4c9fb67072ee9dfb6e5a2c45ae2eaec5cf1" => :arm64_big_sur
    sha256 "4ac6f93f69d971dd2327103100d8eab058def44a0b160e1b6a6f359fa61ddefd" => :catalina
    sha256 "ec2178559d5a797acfc452d2dd2b2e08cf34b377739d3864f24043cd0d31e20f" => :mojave
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
