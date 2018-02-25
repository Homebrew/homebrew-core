class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"

  bottle do
    sha256 "f1fa12f441547b7bf7bdcc858e874e67213256bb82c63d0de068cb32dc515be7" => :high_sierra
    sha256 "eb3764603ef20c1de8be2ebe86cb1914577589faf2b1a09fe4a60e586fbd5ac1" => :sierra
    sha256 "b51cba6f8ce3bbceec1a030042f2d2c74219a9ad1ccd6dcce4b416a06950cda9" => :el_capitan
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
