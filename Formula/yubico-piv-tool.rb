class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.4.2.tar.gz"
  sha256 "33a44018a1a88608058dfe685a4510640d818d4ebcbb2bdb021327497bb45d0a"

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
