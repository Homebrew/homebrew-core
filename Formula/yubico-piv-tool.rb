class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.4.0.tar.gz"
  sha256 "009dbea4256a7a49820962da22eb872e8d21b9126f92787a50bc896dd5d477df"

  bottle do
    cellar :any
    sha256 "e6ac1b2fa28182ad24812d12ba2da923497e549e84305a64d64f0e7d23088d63" => :el_capitan
    sha256 "e375fe81fe2ebd919d26114036c77a9b0ea1f1a3c1a161cdb4c7068703cc2f18" => :yosemite
    sha256 "e2fc470de0875e2f7ec3f89231fdd98cba32c1bd4bb65082b71c64b2b1ad89d3" => :mavericks
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
