class Usbutils < Formula
  desc "List detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "http://www.linux-usb.org/"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-018.tar.gz"
  sha256 "0048d2d8518fb0cc7c0516e16e52af023e52b55ddb3b2068a77041b5ef285768"
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
    sha256 cellar: :any, arm64_sequoia: "19bc5627cb39ad4877754708f98e513f74d74d51a66a2c40e5fb904b44c97851"
    sha256 cellar: :any, arm64_sonoma:  "04127d6f7b7f69f9cf13d59e64c41f75628b9ac4cd4c72da70d9ee892eec1be5"
    sha256 cellar: :any, arm64_ventura: "620a18e00aedf3f6216972e411044b3b212186daf06de35aaba4c01b0da88b75"
    sha256 cellar: :any, sonoma:        "5a46602f76dd8cc39b901f1ec384593ca95183ecb8c013dd5db6be6692129ef9"
    sha256 cellar: :any, ventura:       "4e352bf259ad82c3c2f794c009cb7adcc3fe29829373720529180c28a03902b5"
    sha256               arm64_linux:   "6e9597423b73e6ccdfb60f53e7af93d8e5d9eafd576b6477fc58bf23ad7d3e88"
    sha256               x86_64_linux:  "b6f4d16b0e4a42673c5725cbc31c25a8bfbe702ca82ecc1b58493248285f57c4"
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
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/24a6945778381a62ecdcc1d78bcc16b9f86778c1/usbutils/portable.patch"
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
