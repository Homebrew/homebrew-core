class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "ftp://ftp.astron.com/pub/tcsh/tcsh-6.22.02.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.22.02.tar.gz"
  sha256 "ed287158ca1b00ba477e8ea57bac53609838ebcfd05fcb05ca95021b7ebe885b"

  bottle do
    sha256 "a3d7610764fe93e875d8bdd0dae00f074afa4e1128f3cb02b2990f7b684276e9" => :catalina
    sha256 "85d8865af8ba2a441ccfa66985d9ba74392f972da105ef09ee09bb24208dd5eb" => :mojave
    sha256 "d77c14d9141f44bc9526fdd543de03ff6f8bca34b33197dd080b1eb65e9750e1" => :high_sierra
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
