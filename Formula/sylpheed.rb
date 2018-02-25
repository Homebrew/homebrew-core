class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"

  bottle do
    sha256 "75b5dbd0527be1ef6803cfece4b0a741a23663a7c2b274e4e6ac4c03861a107d" => :high_sierra
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
