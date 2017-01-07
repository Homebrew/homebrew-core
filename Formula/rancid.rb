class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "http://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.5.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rancid/rancid_3.5.1.orig.tar.gz"
  sha256 "f3657930d6ebf855acd961c9acadeffb050cd9ed79809fad5db1c1f75ecfc711"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cfbb0aedc224af94a7dd197a2b014a913c7ac37ed14e6f7a3caa19020b59c01" => :sierra
    sha256 "5765b6f666386f660b1906bf9769fb4146c1b8455ab709976653281a98cffc4e" => :el_capitan
    sha256 "8d354a975bde4553ecfa9092cf12024d837246d6f85b1f0ce80415ba641e9a20" => :yosemite
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
