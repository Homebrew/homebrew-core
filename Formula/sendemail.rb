class Sendemail < Formula
  desc "Email program for sending SMTP mail"
  # Alternate: https://freshmeat.sourceforge.io/projects/sendemail/
  homepage "https://web.archive.org/web/20191013154932/caspian.dotconf.net/menu/Software/SendEmail/"
  url "http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz"
  sha256 "6dd7ef60338e3a26a5e5246f45aa001054e8fc984e48202e4b0698e571451ac0"
  license "GPL-2.0+"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60b99fa4f05c5ee4f2b85c4529e8e4a2368d4a16d68246c4d9bb91ba256f828f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de9826d68c6ca9666b3ec31462cee9d6ad435dfae72273ffd36856aa5dc95339"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de9826d68c6ca9666b3ec31462cee9d6ad435dfae72273ffd36856aa5dc95339"
    sha256 cellar: :any_skip_relocation, ventura:        "2186ce190b15b6a08c59abf17aaf2865917364a028d0959af9295e42c5ff38cc"
    sha256 cellar: :any_skip_relocation, monterey:       "3d2d838108374473524945ae1cada342aad8e25f77216d15dbf8aae7ff0ded76"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d2d838108374473524945ae1cada342aad8e25f77216d15dbf8aae7ff0ded76"
    sha256 cellar: :any_skip_relocation, catalina:       "3d2d838108374473524945ae1cada342aad8e25f77216d15dbf8aae7ff0ded76"
    sha256 cellar: :any_skip_relocation, mojave:         "3d2d838108374473524945ae1cada342aad8e25f77216d15dbf8aae7ff0ded76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b99fa4f05c5ee4f2b85c4529e8e4a2368d4a16d68246c4d9bb91ba256f828f"
  end

  # Reported upstream: https://web.archive.org/web/20191013154932/caspian.dotconf.net/menu/Software/SendEmail/#comment-1119965648
  patch do
    url "https://raw.githubusercontent.com/mogaal/sendemail/e785a6d284884688322c9b39c0f64e20a43ea825/debian/patches/fix_ssl_version.patch"
    sha256 "0b212ade1808ff51d2c6ded5dc33b571f951bd38c1348387546c0cdf6190c0c3"
  end

  def install
    bin.install "sendEmail"
  end

  test do
    assert_match "sendEmail-#{version}", shell_output("#{bin}/sendEmail", 1).strip
  end
end
