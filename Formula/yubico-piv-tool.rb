class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.4.3.tar.gz"
  sha256 "ea83a11f7db5ac81ebcafe71e102c3a5d694929bb95354c3185c081fa6a86dab"

  bottle do
    cellar :any
    sha256 "61ba623eeb6ae0be4c3ec48493772b61bd3fbc98ef06f00887f88ddd6712f2ad" => :sierra
    sha256 "3b8f82294d2305982ef2328990326d5ca7fed1ad1ded153f2946b5a9b95c9b41" => :el_capitan
    sha256 "c9f40fd5fccd54bd88b7c38582cbe05f8663e3fd30a50ebed537440341b2cfe3" => :yosemite
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
