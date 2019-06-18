class Qemu < Formula
  desc "x86 and PowerPC Emulator"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-4.0.0.tar.xz"
  sha256 "13a93dfe75b86734326f8d5b475fde82ec692d5b5a338b4262aeeb6b0fa4e469"
  revision 1
  head "https://git.qemu.org/git/qemu.git"

  bottle do
    sha256 "bd0284531c4a935378e13c8b810e1442f7d11211ca5d1cfa10c40edcb7b427df" => :mojave
    sha256 "0f36bd1533b41bed6becf996aaeefd2b4e3f02feae804559b9a5a09a965d60b9" => :high_sierra
    sha256 "20224b8121b7231e70478bae10bdae4caad80be08a5fbeeb9b2ec7067f0ba204" => :sierra
  end

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
      --enable-cocoa
      --disable-sdl
      --disable-gtk
    ]
    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

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
