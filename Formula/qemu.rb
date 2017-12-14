class Qemu < Formula
  desc "x86 and PowerPC Emulator"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-2.11.0.tar.bz2"
  sha256 "c4f034c7665a84a1c3be72c8da37f3c31ec063475699df062ab646d8b2e17fcb"
  head "https://git.qemu.org/git/qemu.git"

  bottle do
    sha256 "ec48d836a2d6fd75b3f9369c38f04caa8de892976db86333a7f118210a048ecb" => :high_sierra
    sha256 "dee2e64d11b0c685719152d7a37cfdb8b3e1ce9977a74fa105f36ae18f21a925" => :sierra
    sha256 "aad18d02017bcecc82118fad09f86fd8d286228374c51376ec0d7f10fcda93e0" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "gnutls"
  depends_on "glib"
  depends_on "ncurses"
  depends_on "pixman"
  depends_on "libpng" => :recommended
  depends_on "vde" => :optional
  depends_on "sdl2" => :optional
  depends_on "gtk+" => :optional
  depends_on "libssh2" => :optional
  depends_on "libusb" => :optional

  deprecated_option "with-sdl" => "with-sdl2"

  fails_with :gcc_4_0 do
    cause "qemu requires a compiler with support for the __thread specifier"
  end

  fails_with :gcc do
    cause "qemu requires a compiler with support for the __thread specifier"
  end

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "test-image" do
    url "https://dl.bintray.com/homebrew/mirror/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
      --enable-curses
      --extra-cflags=-DNCURSES_WIDECHAR=1
    ]

    # Cocoa and SDL2/GTK+ UIs cannot both be enabled at once.
    if build.with?("sdl2") || build.with?("gtk+")
      args << "--disable-cocoa"
    else
      args << "--enable-cocoa"
    end

    args << (build.with?("vde") ? "--enable-vde" : "--disable-vde")
    args << (build.with?("sdl2") ? "--enable-sdl" : "--disable-sdl")
    args << (build.with?("gtk+") ? "--enable-gtk" : "--disable-gtk")
    args << (build.with?("libssh2") ? "--enable-libssh2" : "--disable-libssh2")

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qemu-system-i386 --version")
    resource("test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")
  end
end
