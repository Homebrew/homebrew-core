class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  revision 1

  bottle do
    sha256 "7b90f17a71f0bd70435538753b63f18583f4d0ea9a5650a6bb4be5b394088044" => :mojave
    sha256 "382c0840297de273c0fb68ecee4462ca4e91cdd6cd7a56b0164a7456d485ff97" => :high_sierra
    sha256 "99c858ab66bba990574fed5a1b4ba6dcc485c75b15983c12e49039f4c624a138" => :sierra
    sha256 "05959f61b600d6d9f323b29a0085b275442c92499657f7a4750b88a9ec36a60e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl"

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
