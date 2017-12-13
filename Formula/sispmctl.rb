class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "https://sispmctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-4.0/sispmctl-4.0.tar.gz"
  sha256 "442d9bb9774da7214c222144035ac68ad5d25171040ce2731cfdf49b3365cfd5"

  bottle do
    cellar :any
    sha256 "721d04838452da87c60ff09d21e3bc948df16f626adbae7ea8108fb0fc10ebe4" => :high_sierra
    sha256 "4aae3c4b94d58d9b0cee1e8ad3eeed2583e7c247711a764dde0485b89687d9b2" => :sierra
    sha256 "a83e61cd8748b55173148cd71ee71852c257502a633674c01d78c473188ae4c3" => :el_capitan
    sha256 "a3bf8d25e2c4fddb14edf0c77ad4ecbf7773445ee833fed4106efcae03cbe529" => :yosemite
    sha256 "5ce113e27ad2d3cfeeae7317a6614a45659288107910dc63fef605342f0e7d54" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sispmctl -v 2>&1")
  end
end
