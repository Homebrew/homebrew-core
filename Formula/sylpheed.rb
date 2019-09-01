class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  revision 3

  bottle do
    sha256 "0c7cdaa8f1cb2ea0ccd8e2728ecf6066c3a67b71446ebd79821b51e38460d4df" => :mojave
    sha256 "103618c0a4407704ef722ce8506782d7165b70d45c08024e59509600208bedd5" => :high_sierra
    sha256 "e7d84cb55b57fc4b7f8deb2b25ad27a4d3a39ea4278fe06847289ea54ac87a18" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make", "install"
  end

  test do
    system "#{bin}/sylpheed", "--version"
  end
end
