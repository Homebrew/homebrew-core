class Usbutils < Formula
  desc "List detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "http://www.linux-usb.org/"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-020.tar.gz"
  sha256 "fed292b2a3dce83464ce9e96e7eaf301f58b3bf0104872b6a75edac14c907ff2"
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
    sha256 cellar: :any, arm64_golden_gate: "54a0c1da8be792d7614a32937d0f9e75172a6e02bacdbd6f000ead2a5d4467bf"
    sha256 cellar: :any, arm64_tahoe:       "c0b1e16c2f54b573672c30e5e6c077aff58d68f909865e34733246746e0026ca"
    sha256 cellar: :any, arm64_sequoia:     "791099dc9c3b55360d631a6956983122b8116db79707cd7bc749d209f16fb4ff"
    sha256 cellar: :any, arm64_linux:       "be51576c1650fcf02881184ccbe647c89042e7e9f452cbc42fcae3e4a4016d79"
    sha256 cellar: :any, x86_64_linux:      "a99f4203ddbd2372e87a6bde23a32de74d20ff7fc4f5bc1126145c22fff76579"
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
    file "Patches/usbutils/portable.patch"
    type :unofficial
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
