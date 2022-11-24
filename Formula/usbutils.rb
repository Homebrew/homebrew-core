class Usbutils < Formula
  desc "List detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "http://www.linux-usb.org/"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-014.tar.gz"
  sha256 "59398ab012888dfe0fd12e447b45f36801e9d7b71d9a865fc38e2f549afdb9d0"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f20cbfbd81aa504ca6f9f5f9c22bc07c25aba128cb661daa0e5b7216460850a4"
    sha256 cellar: :any,                 arm64_monterey: "b92a68d48cfd148d424c9e856b58a6f35409f39943ec03571647454b1f5e951a"
    sha256 cellar: :any,                 arm64_big_sur:  "4348cacea6a03dd09f24fb6b81d9c81db1d5b2e7b4aacf72aa23e90e8c4e4d44"
    sha256 cellar: :any,                 ventura:        "7da257ddc8e3b4fe04d6a7ca660703b2c3396e41e2051c3d136714ca26482491"
    sha256 cellar: :any,                 monterey:       "d906f5f22f4cea31c8e4ba89f734639fbbd5719da4312c146c801980214cad3f"
    sha256 cellar: :any,                 big_sur:        "67d46074026c0a78518a2d5b00e0a3d96a64b4b33d256b1bddfe9c0d9bceda89"
    sha256 cellar: :any,                 catalina:       "8f0724c218cc91cfbb9da1a69db8c67962f296581aaaaa1305fc8af77f569f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb9055ef6f7e14c7ada67c07f72e85ee24399e87fb4ad67dd67811616679e1c"
  end

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
