class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "https://www.shrubbery.net/rancid/"
  url "https://www.shrubbery.net/pub/rancid/rancid-3.12.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/r/rancid/rancid_3.12.orig.tar.gz"
  sha256 "b1c1415d16ac291e29ff356a3c4f688160f07f1a091869290a95cd1793d4d3fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "39ec33c962ee398c0e8bbf842debcd8f68142c32c6c6c43c75e52d2b8f453c6a" => :catalina
    sha256 "4e95ce8c637515da76bad63aeafd50ddcfd6efa8cb93cb233a1619a0174b71bc" => :mojave
    sha256 "3fe616a75b533dc7d4b8989f8719d6eb9d78628572f1e0769c6ddd6e4e769aae" => :high_sierra
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
