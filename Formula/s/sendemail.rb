class Sendemail < Formula
  desc "Email program for sending SMTP mail"
  homepage "http://caspian.dotconf.net/menu/Software/SendEmail/"
  url "http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz"
  sha256 "6dd7ef60338e3a26a5e5246f45aa001054e8fc984e48202e4b0698e571451ac0"
  license "GPL-2.0-or-later"

  livecheck do
    skip "Not actively developed or maintained"
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "113001c5e97ed667b4f8401c335b3a337a7354b1562ca8b40b6499e6cdb68278"
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
