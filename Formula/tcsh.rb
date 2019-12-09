class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.22.02.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.22.02.tar.gz"
  sha256 "ed287158ca1b00ba477e8ea57bac53609838ebcfd05fcb05ca95021b7ebe885b"

  bottle do
    sha256 "6c5cd56d3e25c096ab2488b74a0772bfc24fb7e5b05b44323e850c96d3ca6324" => :catalina
    sha256 "36e8a812e6bd9175cf45a13e65aa2f7ef6291228d89ab0d47d274e9c205c079f" => :mojave
    sha256 "c22bfc5464b098433c9335ce61bd3b1817f58419e00245df266aa66d4a9c899b" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"test.csh").write <<~EOS
      #!#{bin}/tcsh -f
      set ARRAY=( "t" "e" "s" "t" )
      foreach i ( `seq $#ARRAY` )
        echo -n $ARRAY[$i]
      end
    EOS
    assert_equal "test", shell_output("#{bin}/tcsh ./test.csh")
  end
end
