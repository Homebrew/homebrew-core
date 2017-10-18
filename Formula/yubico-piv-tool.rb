class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.4.4.tar.gz"
  sha256 "ab0eac3f78e9e01538723f631ed6042504409a1ab0342973e2bd52f2c68a3769"

  bottle do
    cellar :any
    sha256 "db317d0ba65e375ff13918fdc8b0fd2ff4dabcc69f71e090c4c1bad4d5722b25" => :high_sierra
    sha256 "2b82a5831449f91ef8a7f7ec2900b867107353ee3e5f3b00fbcb69130341292a" => :sierra
    sha256 "42a20303f0d5a0cf81aea803427138893411e5111e629bc94427332a87241fcc" => :el_capitan
    sha256 "2b3fa02ae52f8868e111144c7fd8d581c92fba89c8dd0de84de3b7e9e620e54e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
