class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "http://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.5.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rancid/rancid_3.5.1.orig.tar.gz"
  sha256 "f3657930d6ebf855acd961c9acadeffb050cd9ed79809fad5db1c1f75ecfc711"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6cac3f34c58ad29d2e2d94615bd541ce9fa899f618479845fed9bbe81ed716c0" => :sierra
    sha256 "549a0b0725cbabe8e1e2e61ab3fc3853c32a7cb4ae4f2e33413d9c34fe3fe6f9" => :el_capitan
    sha256 "cbd473fbe3fc393010cc05f57f2c419a22a773201cae804c831794bb0cb893e6" => :yosemite
    sha256 "d1933933b5d1c6af784af00697791a9ed8e5fa56c3b6fc4ae6ef8b7656dafef2" => :mavericks
  end

  conflicts_with "par", :because => "both install `par` binaries"

  def install
    system "./configure", "--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"rancid.conf").write <<-EOS.undent
      BASEDIR=#{testpath}; export BASEDIR
      CVSROOT=$BASEDIR/CVS; export CVSROOT
      LOGDIR=$BASEDIR/logs; export LOGDIR
      RCSSYS=git; export RCSSYS
      LIST_OF_GROUPS="backbone aggregation switches"
    EOS
    system "#{bin}/rancid-cvs", "-f", testpath/"rancid.conf"
  end
end
