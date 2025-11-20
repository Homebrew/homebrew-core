class Usbutils < Formula
  desc "List detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "http://www.linux-usb.org/"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-019.tar.gz"
  sha256 "347c52b65a6aeb22cfe3af8382192004f99725850e1dc5f705336e54cf6d59fc"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    any_of: ["GPL-2.0-only", "GPL-3.0-only"],
  ]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/"
    regex(/href=.*?usbutils[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "26e37532e86411091b25054bfc3967d825fd533557c8a59296867caab2fb9c95"
    sha256 cellar: :any, arm64_sequoia: "3fd964e13e53ac02a5ab1e3aad9507622a2ca4b950f53a39fc644492c7e0bb25"
    sha256 cellar: :any, arm64_sonoma:  "625af4354b888ad7fd99c48bd952b0f90191ca0f5212a77a4e5878d8c3336f05"
    sha256 cellar: :any, sonoma:        "235c82fe47c5faec50df91713b449941b4a89d8895b87c6b5950e78d2e099cb6"
    sha256               arm64_linux:   "9dd93abd2b124a8d0beb4c155fcd417ec99b837d38db7a7b4f8b82745761d51a"
    sha256               x86_64_linux:  "7d95c8f655bf97ceb6e232dbdbb27e9ce977dd6590311bff52077f652d0512b0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  on_linux do
    depends_on "systemd"
  end

  conflicts_with "lsusb", "lsusb-laniksj", because: "both provide an `lsusb` binary"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/usbutils/portable.patch"
    sha256 "ec09531017e1fa45dbc37233b286a736a24d7f98668e38a92e3697559f739c7f"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      usbhid-dump requires either proper code signing with com.apple.vm.device-access
      entitlement or root privilege
    EOS
  end

  test do
    assert_empty shell_output("#{bin}/lsusb -d ffff:ffff", 1)
  end
end
