class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "https://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.10.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/r/rancid/rancid_3.10.orig.tar.gz"
  sha256 "7781af6df112fa45655485d178055b013cdce32523c6737dd593ca645898bafe"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b54b09695a994ec13fbf8f272f1bdabe465cc6c009bff7de96f0dc40efed9cd" => :catalina
    sha256 "b3838146e796c859d8736d8e9f9c63e12cfabbecbce21afa2d97cc37e1a4c9b3" => :mojave
    sha256 "b3966784ac41c2b41d1e3ba8713b52b238da54800535aebc09aff833582c0824" => :high_sierra
    sha256 "5145ae1c88008071a8bbde7eac2e897d9dae1c74b32e6b9258455f55877066fa" => :sierra
  end

  conflicts_with "par", :because => "both install `par` binaries"

  def install
    system "./configure", "--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"rancid.conf").write <<~EOS
      BASEDIR=#{testpath}; export BASEDIR
      CVSROOT=$BASEDIR/CVS; export CVSROOT
      LOGDIR=$BASEDIR/logs; export LOGDIR
      RCSSYS=git; export RCSSYS
      LIST_OF_GROUPS="backbone aggregation switches"
    EOS
    system "#{bin}/rancid-cvs", "-f", testpath/"rancid.conf"
  end
end
