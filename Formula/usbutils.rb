class Usbutils < Formula
  desc "List detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "http://www.linux-usb.org/"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-015.tar.gz"
  sha256 "2b8140664578f39c3f6f0166a1b950f8655304e63e3d7f89899acb99bc5cb8e7"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/"
    regex(/href=.*?usbutils[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e99cf12fb0f563a2b3d1989c9d48a1e32b50929698adce3b55ec987cfebd7bf"
    sha256 cellar: :any,                 arm64_monterey: "c67a9bb88a9cd63c920331a86db072da46957021de78c4a6f3d8283978b85473"
    sha256 cellar: :any,                 arm64_big_sur:  "947ef6a6c17f7874a41d3c2320f91fa494ca29ff9c61e23c8de1964407853d7e"
    sha256 cellar: :any,                 ventura:        "f8adae8b13b1fbf6df63cd14b9f0da8449c6cbbbece3ced1e11ede87b7f46070"
    sha256 cellar: :any,                 monterey:       "df6424c3b6aedb0cb484679980e452ea4af24cd65ac94f674084f209f19f0915"
    sha256 cellar: :any,                 big_sur:        "d1a3c62a690bf4bf4697ce22690468495a97e79bece17d464a6b961de8fa7c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ada2b7a26c837e0cc24b81aec12a29d5bbff51366a4222a6b14ae5013e102b27"
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
