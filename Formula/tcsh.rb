class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.22.03.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.22.03.tar.gz"
  sha256 "be2cfd653d2a0c7f506d2dd14c12324ba749bd484037be6df44a3973f52262b7"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "db17d78c13b5c84ab7d63a0a817e90d4952bd912e05ded54b7989031244abeeb"
    sha256 big_sur:       "b72af846ad95fa94d102ea96ce87f267c053382fc10127df7d1b20ed66048000"
    sha256 catalina:      "888b1e8c5d9eefbd64c2e99d20d9358bc6a95b4bb2dc4f7857c75f5ce27801c5"
    sha256 mojave:        "5a46aa98b8f49e3c284e817a18f48ff511f2ec6af9a7d3a8a9af2f24bcc3ad96"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
    bin.install_symlink "tcsh" => "csh"
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
