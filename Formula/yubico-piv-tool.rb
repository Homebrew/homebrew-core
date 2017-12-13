class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.5.0.tar.gz"
  sha256 "c18375179ba25bf9d61365b3903f033f112897bbd54ca63c62fa153f2d05aaab"

  bottle do
    cellar :any
    sha256 "27dc927312080b5b29cf97391b0d8457f1226cda154fe5b6f57900ab6b084d09" => :high_sierra
    sha256 "01428e4bf53de23c6858f0fcc2b9c56f1f6baca073a350a4c7d4e676eb985497" => :sierra
    sha256 "184f77d93b88564c7fd82b5c928f433a521bd3d2cd0da16a3915e307ab2528f6" => :el_capitan
  end

  depends_on "check" => :build
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
