class Qemu < Formula
  desc "x86 and PowerPC Emulator"
  homepage "https://www.qemu.org/"
  head "https://git.qemu.org/git/qemu.git"

  stable do
    url "https://download.qemu.org/qemu-2.12.0.tar.bz2"
    sha256 "c9f4a147bc915d24df9784affc611a115f42d24720a89210b479f1ba7a3f679c"

    # https://lists.nongnu.org/archive/html/qemu-devel/2018-06/msg03856.html
    # https://github.com/Homebrew/homebrew-core/issues/27146
    patch do
      url "https://git.qemu.org/?p=qemu.git;a=patch;h=656282d245b49b84d4a1a47d7b7ede482d541776"
      sha256 "9f34465a06115bbffa171502e863e90a776ff6f897cd82ccebe287a91daad975"
    end
  end

  bottle do
    sha256 "ef4da4274e0e582cff223d46736d386ea78444e7943bcb47f4541bec9e6b7786" => :high_sierra
    sha256 "c896fa77d0b63a9c7fc5e7ad9ee64ab72c3d0995cc1031ef9326b41a3d189240" => :sierra
    sha256 "95a8d1f152c57161dee4f0f36a7409ff413631d0ca5afb7fe5d986b13abaf0ae" => :el_capitan
  end

  devel do
    url "https://download.qemu.org/qemu-3.0.0-rc3.tar.xz"
    sha256 "44279480069daaf6394232b1955c0a6109a767e636551a113f20c7a603f8c27c"
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
  depends_on "gtk+3" => :optional
  depends_on "libssh2" => :optional
  depends_on "libusb" => :optional

  deprecated_option "with-sdl" => "with-sdl2"
  deprecated_option "with-gtk+" => "with-gtk+3"

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
    if build.with?("sdl2") || build.with?("gtk+3")
      args << "--disable-cocoa"
    else
      args << "--enable-cocoa"
    end

    args << (build.with?("vde") ? "--enable-vde" : "--disable-vde")
    args << (build.with?("sdl2") ? "--enable-sdl" : "--disable-sdl")
    args << (build.with?("gtk+3") ? "--enable-gtk" : "--disable-gtk")
    args << (build.with?("libssh2") ? "--enable-libssh2" : "--disable-libssh2")

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    expected = build.stable? ? version.to_s : "QEMU Project"
    assert_match expected, shell_output("#{bin}/qemu-system-i386 --version")
    resource("test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")
  end
end
