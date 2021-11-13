class Usbutils < Formula
  desc "List detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "http://www.linux-usb.org/"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-014.tar.gz"
  sha256 "59398ab012888dfe0fd12e447b45f36801e9d7b71d9a865fc38e2f549afdb9d0"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  conflicts_with "lsusb", because: "both provide an `lsusb` binary"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9ef20debdfb9995fec347e401f2b5eb7b6c76f07/usbutils/portable.patch"
    sha256 "645cf353cd2ce0c0ee4f8c4129c3b39488c23d0ab13f4cfdef07f55f23381933"
  end

  def install
    system "autoreconf", "--verbose", "--force", "--install"
    system "./configure", "--disable-debug",
                          *std_configure_args

    system "make", "install"
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
