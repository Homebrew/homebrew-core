class Qemu < Formula
  desc "x86 and PowerPC Emulator"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-3.1.0.tar.xz"
  sha256 "6a0508df079a0a33c2487ca936a56c12122f105b8a96a44374704bef6c69abfc"
  revision 1
  head "https://git.qemu.org/git/qemu.git"

  bottle do
    rebuild 1
    sha256 "dd7cb5e2b5d7fc3738c72f1e8fe47ee2fd335223b1ec4694749800b6ba87d552" => :mojave
    sha256 "86cad762d521c4170c0af2fa2932e0d123db2838097895e155f49f12525eb90a" => :high_sierra
    sha256 "ff6d0904a871d605aefda6cd0574a0ccfb09b758cca832d347ff843eb52f97fd" => :sierra
  end

  deprecated_option "with-sdl" => "with-sdl2"
  deprecated_option "with-gtk+" => "with-gtk+3"

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libssh2"
  depends_on "libusb"
  depends_on "ncurses"
  depends_on "pixman"
  depends_on "vde"
  depends_on "gtk+3" => :optional
  depends_on "sdl2" => :optional

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
      --enable-libssh2
      --enable-vde
      --extra-cflags=-DNCURSES_WIDECHAR=1
    ]

    # Cocoa and SDL2/GTK+ UIs cannot both be enabled at once.
    if build.with?("sdl2") || build.with?("gtk+3")
      args << "--disable-cocoa"
    else
      args << "--enable-cocoa"
    end

    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    args << (build.with?("sdl2") ? "--enable-sdl" : "--disable-sdl")
    args << (build.with?("gtk+3") ? "--enable-gtk" : "--disable-gtk")

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
