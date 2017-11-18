class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "http://www.shrubbery.net/rancid/"
  url "ftp://ftp.shrubbery.net/pub/rancid/rancid-3.7.tar.gz"
  sha256 "9c6befff78d49d8d0757a2b57b6cfdfef55cadcbc1fa6fbe1ab9424335d51f7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "b016dd160445f121a4404cc7f9556b173b580d88db53799f720ae27088ac35c2" => :high_sierra
    sha256 "a60d7c30da581df22d0950a56a040ff4b88385bdf411d0d5a215791229e830aa" => :sierra
    sha256 "f889063d5ec93094647aad6ef6f0958dc730ce23ec72be6826ac121471bb75d7" => :el_capitan
    sha256 "07fb9fed57cbb0c6ee07d9bf12796ceb4588a6990d68648c854047f815693b22" => :yosemite
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
