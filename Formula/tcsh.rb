class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.22.03.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.22.03.tar.gz"
  sha256 "be2cfd653d2a0c7f506d2dd14c12324ba749bd484037be6df44a3973f52262b7"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "4984599cbefc72104b17434f89aa257e0b2de09605a53ac66e9d07e4804b344d"
    sha256 big_sur:       "e572fcc4259db31e54c25ccf22d736637cfce0801f038691b86d5d68847d6603"
    sha256 catalina:      "2feecc5bd032b40e4673125431957d89a37a54aac8d4e0b5849fd9fa33aa7bfa"
    sha256 mojave:        "1a278f9965f6b362035623cf793afee82e0039277f61f06f32499f7bdf0ec0ad"
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
