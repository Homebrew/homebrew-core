class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  revision 3

  bottle do
    sha256 "3089d6d9d46182e38a15c19b4632d2bf34399c16afb9e243e32dec7d93de4232" => :mojave
    sha256 "f1c42b8305375ac7a145d0c36c0d0b4d30d75ff7e4d6a226dd9c82d41ae19ee5" => :high_sierra
    sha256 "7d58f64fbbd0f0ab47bfbbd2f17b3d1997b4ca93e90bc3fb6875f119a4602b7b" => :sierra
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
