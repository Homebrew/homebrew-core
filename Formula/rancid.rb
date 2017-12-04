class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "http://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.7.tar.gz"
  sha256 "9c6befff78d49d8d0757a2b57b6cfdfef55cadcbc1fa6fbe1ab9424335d51f7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d35aeb470a1d217d32279f2a45d513c0a8b50191022d48a7c25da7e7f830db2f" => :high_sierra
    sha256 "9bb1c1edb5c94a70de4ea3634146d45be62bc67b82fb967448b2a645946ffd1f" => :sierra
    sha256 "d6429e2f77b8d616449ee4af91adda8b24a94b2f73d314070cc2300c695f6a43" => :el_capitan
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
