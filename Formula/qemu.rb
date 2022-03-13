class Qemu < Formula
  desc "Emulator for x86 and PowerPC"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-6.2.0.tar.xz"
  sha256 "68e15d8e45ac56326e0b9a4afa8b49a3dfe8aba3488221d098c84698bca65b45"
  license "GPL-2.0-only"
  revision 1
  head "https://git.qemu.org/git/qemu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "fcc3b1a8139f70dae57f5449f3856f9b3b67448ee0623e64da1e47dc255b46f6"
    sha256 arm64_big_sur:  "6a1174b4d22ef8175fab39bfdc9717eaa47e57c37584b31e65d0a2345c9f4f4e"
    sha256 monterey:       "d086496727bc70e98e33c48d7815d39a113ebeccb45a6958dacad8cb7e388e8f"
    sha256 big_sur:        "b1fa43a439861a8b8d8b637bde1bd0ab8a068a6a5332febdaa5d371cb2f47493"
    sha256 catalina:       "aa5c01cc995b014f34c8186aa474d6e57afc39bfe30f5bc0369909bc8e4baefa"
    sha256 x86_64_linux:   "5270435ffa522ff52f7b20b09f4723c320633295c0057724e8ffc47ea6097eb7"
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
    depends_on "attr"
    depends_on "gcc"
    depends_on "gtk+3"
    depends_on "libcap-ng"
  end

  fails_with gcc: "5"

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "homebrew-test-image" do
    url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  # The following patches add 9p support to darwin.  They can
  # be deleted when qemu-7 is released.
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/e0bd743bb2dd4985791d4de880446bdbb4e04fed.diff"
    sha256 "9168d424f7bcabb74fdca35fd4d3db1279136ce03d656a2e0391aa4344244e49"
  end
  patch do
    url "https://raw.githubusercontent.com/baude/homebrew-qemu/798fdd7c6e2924591f45b282b3f59cb6e9850504/add_9p-util-linux.diff"
    sha256 "e2835578eeea09b75309fc3ac4a040b47c0ac8149150d8ddf45f7228ab7b5433"
  end
  patch do
    url "https://raw.githubusercontent.com/baude/homebrew-qemu/798fdd7c6e2924591f45b282b3f59cb6e9850504/remove_9p-util.diff"
    sha256 "ccf31a8e60ac7fc54fd287eca7e63fe1c9154e346d2a1367b33630227b88144d"
  end
  patch do
    url "https://raw.githubusercontent.com/ashley-cui/homebrew-podman/e1162ec457bd46ed84aef9a0aa41e80787121088/change.patch"
    sha256 "af8343144aea8b51852b8bf7c48f94082353c5e0c57d78fc61e7c3e4be3658b9"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/f41db099c71151291c269bf48ad006de9cbd9ca6.diff"
    sha256 "1769d60fc2248fc457846ec8fbbf837be539e08bd0f56daf6ec9201afe6c157e"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/6b3b279bd670c6a2fa23c9049820c814f0e2c846.diff"
    sha256 "bde6fa9deffeb31ca092f183a9bffc1041501c2532a625f8875fa119945049b8"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/67a71e3b71a2834d028031a92e76eb9444e423c6.diff"
    sha256 "60f38699e2488f854c295afbfea56f30fce1ebc0d2a7dcddf8bedba2d14533b1"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/38d7fd68b0c8775b5253ab84367419621aa032e6.diff"
    sha256 "b89ed2a06d1e81cb18b7fab0b47313d8a3acc6be70a4874854c0cc925fc6e57f"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/57b3910bc3513ab515296692daafd1c546f3c115.diff"
    sha256 "4bbd1f2d209f099fb2b075630b67a3d08829d67c56edcb21fc5688f66a486296"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/b5989326f558faedd2511f29459112cced2ca8f5.diff"
    sha256 "5c53c4cc28229058f9fac3eed521d62edf9b952bf24eb18790a400a074ed6f0b"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/029ed1bd9defa33a80bb40cdcd003699299af8db.diff"
    sha256 "a349c6de07fcf8314a1d84cacc05c68573728641cc5054d0fc149d14e1c9bed8"
  end
  patch do
    url "https://gitlab.com/qemu-project/qemu/-/commit/d3671fd972cd185a6923433aa4802f54d8b62112.diff"
    sha256 "f40dd472ec4dcbf6f352338de85c1aba5a92a3b9f0a691f8ae51e298e2b5a273"
  end
  patch do
    url "https://raw.githubusercontent.com/NixOS/nixpkgs/8fc669a1dd84ae0db237fdb30e84c9f47e0e9436/pkgs/applications/virtualization/qemu/allow-virtfs-on-darwin.patch"
    sha256 "61422ab60ed9dfa3d9fe8a267c54fab230f100e9ba92275bc98cf5da9e388cde"
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
      --enable-virtfs
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
