class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.22.02.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.22.02.tar.gz"
  sha256 "ed287158ca1b00ba477e8ea57bac53609838ebcfd05fcb05ca95021b7ebe885b"

  bottle do
    rebuild 1
    sha256 "d885eaa1411e8fc46cb39e4a11254d37c8dc90aded6684631bfc312d7115c9fa" => :catalina
    sha256 "a070c8c6b4f2ce38be5a84109d307078545911f2a731b0e5e140856a6711bce4" => :mojave
    sha256 "2f81edc8ce902ce12e722003aec60d62d21ca7be7a944b3b2f571b9e9d7d1282" => :high_sierra
  end

  uses_from_macos "ncurses"

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
