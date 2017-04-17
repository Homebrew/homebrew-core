class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "http://sylpheed.sraoss.jp/en/"
  url "http://sylpheed.sraoss.jp/sylpheed/v3.5/sylpheed-3.5.1.tar.bz2"
  sha256 "3a5a04a13a0e2f32cdbc6e09d92b5143ca96df5fef23425cd81d96b8bd5b1087"

  bottle do
    sha256 "4d7e9304cf76af157b5024996fd0ac863ab29ee28314f3d7462420c03a6a0d89" => :sierra
    sha256 "abad4de7236559d4810890ef33e6900ce06209660e89fbdb970fab25331cd948" => :el_capitan
    sha256 "ab1789e58f138cbc274af2fa9119c166b66ade4d60a3a9004905fb76609e997e" => :yosemite
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
