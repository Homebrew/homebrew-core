class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "http://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rancid/rancid_3.2.orig.tar.gz"
  sha256 "e7da7242c1f072700b8d6077314be91c1fabe62528de2bdf91349b7094729e75"

  bottle do
    cellar :any_skip_relocation
    revision 1
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
