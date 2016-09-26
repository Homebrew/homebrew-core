class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "http://sispmctl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-3.1/sispmctl-3.1.tar.gz"
  sha256 "e9a99cc81ef0a93f3484e5093efd14d93cc967221fcd22c151f0bea32eb91da7"

  bottle do
    cellar :any
    sha256 "4aae3c4b94d58d9b0cee1e8ad3eeed2583e7c247711a764dde0485b89687d9b2" => :sierra
    sha256 "a83e61cd8748b55173148cd71ee71852c257502a633674c01d78c473188ae4c3" => :el_capitan
    sha256 "a3bf8d25e2c4fddb14edf0c77ad4ecbf7773445ee833fed4106efcae03cbe529" => :yosemite
    sha256 "5ce113e27ad2d3cfeeae7317a6614a45659288107910dc63fef605342f0e7d54" => :mavericks
  end

  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
