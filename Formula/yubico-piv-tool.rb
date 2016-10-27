class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.4.2.tar.gz"
  sha256 "33a44018a1a88608058dfe685a4510640d818d4ebcbb2bdb021327497bb45d0a"

  bottle do
    cellar :any
    sha256 "b2d4198186db6da47216d9d26192880015d1c8f4bd4782428a0edba43e496ad4" => :sierra
    sha256 "46bf3f0be1051de87c58849f660fe1a83cdbf1c402cfa1191268ce98bd2ee746" => :el_capitan
    sha256 "d715ee612c34665082aa9b13ab24daeda752e2ad5c2e97e73775477ab9625776" => :yosemite
    sha256 "6332e35a07e75145472633ff0bdd3fb1c1975611a813e283683f478079c52af3" => :mavericks
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
