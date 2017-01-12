class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "http://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.6.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rancid/rancid_3.6.2.orig.tar.gz"
  sha256 "23751829c9bacdd07f90512271265c0cac279ca2f36ac86be815dd21831c253d"

  bottle do
    cellar :any_skip_relocation
    sha256 "745dd42957fdc73dda7994782045b04a10805f2fb4c58aee4188d333838b07c3" => :sierra
    sha256 "9bebc4fa99124a06242fd98dc96c02128921e6c0fa2c5d93beee457261dde852" => :el_capitan
    sha256 "b78402959ada869064b10b7b8c358cff85b86c14e1147c9660245a7883e1f963" => :yosemite
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
