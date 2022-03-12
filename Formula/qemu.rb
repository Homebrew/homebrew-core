class Qemu < Formula
  desc "Emulator for x86 and PowerPC"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-6.2.0.tar.xz"
  sha256 "68e15d8e45ac56326e0b9a4afa8b49a3dfe8aba3488221d098c84698bca65b45"
  license "GPL-2.0-only"
  revision 1
  head "https://git.qemu.org/git/qemu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "ebb70e2c067ed6b7675d2f3f58d994c70d5816bf43efcaffbb14c3b302486228"
    sha256 arm64_big_sur:  "f1be222ea617fbe9b897dcb60c54a90b0b5cdd86ea24322e47fd0e0473618b24"
    sha256 monterey:       "b3ad84cd4e4fd69606c4d4ed1423092e8bae32a7098ea51a29adcdebb55cb0f9"
    sha256 big_sur:        "eb508a74b42071dd0444d70dc90f854f63b6f79fe72d650c246dff8a86fb1d07"
    sha256 catalina:       "a4e9967cf7838e9642a8e38d3c0bcc4733270e4144fbb867f09311f06f415ad1"
    sha256 x86_64_linux:   "76787d26de9a128dd62506c1ecfcae3be118ce20b90a3427c9bceb4897bbb15d"
  end

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "vde"

  on_linux do
    depends_on "gcc"
    depends_on "gtk+3"
  end

  fails_with gcc: "5"

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "homebrew-test-image" do
    url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  # Backport the following commits from QEMU master (QEMU 7):
  # - ad99f64f hvf: arm: Use macros for sysreg shift/masking
  # - 7f6c295c hvf: arm: Handle unknown ID registers as RES0
  #
  # These patches are required for running the following guests:
  # - Linux 5.17
  # - Ubuntu 21.10, kernel 5.13.0-35.40  (March 2022)
  # - Ubuntu 20.04, kernel 5.4.0-103.117 (March 2022)
  #
  # See https://gitlab.com/qemu-project/qemu/-/issues/899
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/ad99f64f1cfff7c5e7af0e697523d9b7e45423b6.diff"
    sha256 "004e1b7b7c422628b3d6a95827bfca8a19ec36c0d2a0e6ee1f1046d0a2a101ad"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/7f6c295cdfeaa229c360cac9a36e4e595aa902ae.diff"
    sha256 "a8d02dcad74da3c3cb18c113a195477dcb76d1128761e48e6827f04d235ed3ce"
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
      --enable-libssh
      --enable-slirp=system
      --enable-vde
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --disable-sdl
    ]
    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    args << "--disable-gtk" if OS.mac?
    args << "--enable-cocoa" if OS.mac?
    args << "--enable-gtk" if OS.linux?

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    expected = build.stable? ? version.to_s : "QEMU Project"
    assert_match expected, shell_output("#{bin}/qemu-system-aarch64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-alpha --version")
    assert_match expected, shell_output("#{bin}/qemu-system-arm --version")
    assert_match expected, shell_output("#{bin}/qemu-system-cris --version")
    assert_match expected, shell_output("#{bin}/qemu-system-hppa --version")
    assert_match expected, shell_output("#{bin}/qemu-system-i386 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-m68k --version")
    assert_match expected, shell_output("#{bin}/qemu-system-microblaze --version")
    assert_match expected, shell_output("#{bin}/qemu-system-microblazeel --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips64el --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mipsel --version")
    assert_match expected, shell_output("#{bin}/qemu-system-nios2 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-or1k --version")
    assert_match expected, shell_output("#{bin}/qemu-system-ppc --version")
    assert_match expected, shell_output("#{bin}/qemu-system-ppc64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-riscv32 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-riscv64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-rx --version")
    assert_match expected, shell_output("#{bin}/qemu-system-s390x --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sh4 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sh4eb --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sparc --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sparc64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-tricore --version")
    assert_match expected, shell_output("#{bin}/qemu-system-x86_64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-xtensa --version")
    assert_match expected, shell_output("#{bin}/qemu-system-xtensaeb --version")
    resource("homebrew-test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")
  end
end
