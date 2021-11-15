class XmlCoreutils < Formula
  desc "Powerful interactive system for text processing"
  homepage "https://www.lbreyer.com/xml-coreutils.html"
  url "https://www.lbreyer.com/gpl/xml-coreutils-0.8.1.tar.gz"
  sha256 "7fb26d57bb17fa770452ccd33caf288deee1d757a0e0a484b90c109610d1b7df"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?xml-coreutils[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "27121488a3c491191c025a484e1f76d0ad162f19ba6cddf733a5826cdddf05a9"
    sha256 cellar: :any, arm64_big_sur:  "7094a5673f2ab6ba2fa45c587397650f4d9b2ccea1ab66925f58ef776683298d"
    sha256 cellar: :any, monterey:       "80d3c4547a1f1a152c3f37477430b6d1628cba725ac191d28f4c024cf064dcfa"
    sha256 cellar: :any, big_sur:        "6e5400968229c313cab973cffdbb77b88c30a5301066626b34b96e0a46578fc8"
    sha256 cellar: :any, catalina:       "e098f5b2d9af801bb12c65044668091b175dcca43cec7251acb0d3e1ccad4fed"
    sha256 cellar: :any, mojave:         "9be4dcb20fd773296a26df8495c5097b273a2a0d89f6abc1545a713ba94e1b07"
    sha256 cellar: :any, high_sierra:    "83023841339cb02ad53de64e30aa0c491e4acd4ae4602bd84847aca42ac02e00"
    sha256 cellar: :any, sierra:         "5f7519c9be40f731b0dca6238b3bedf4070f0663fc47ab8e4b0eff02d187718c"
    sha256 cellar: :any, el_capitan:     "19bdcacd49657e78f82fd7743a50266ff4945e644b069ac2c39a8787a57911a5"
    sha256 cellar: :any, yosemite:       "1342c807e5ddc23a72e750f07258864fdf2fc1a8ce9072cb7797955fdd0e3656"
  end

  depends_on "s-lang"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <hello>world!</hello>
    EOS
    assert_match(/0\s+1\s+1/, shell_output("#{bin}/xml-wc test.xml"))
  end
end
