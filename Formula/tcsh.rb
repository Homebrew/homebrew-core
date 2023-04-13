class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.09.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.09.tar.gz"
  sha256 "c2e78a0c837c673410fe4b14de412bb642dc2dc61f56776e052860f82ad9eb9e"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "54d2fc04e782d4f32da3ae84299a5604b1f6ecf45acc221fe561f1f0d09ca768"
    sha256 arm64_monterey: "45b2150802cce08eaa2042fb0b08f41106ac2059eb69a7ab3b9f3eabba121c75"
    sha256 arm64_big_sur:  "35c99295a8b2e08338215ad40c9513e38c37651070b78d4be7e560b441c937a4"
    sha256 ventura:        "6d22859c1f09cab529a8933d1bb078c231feda0dbc862e1977d1bfb3e36c5073"
    sha256 monterey:       "5c1677a79680f1612c63e6428f7fd89ba84158accb14ffbb05b4129aa5da7480"
    sha256 big_sur:        "612d6c88c2dbb756ba26da58c56e2e05b90f3db3c1cca74baba20b537d7975b4"
    sha256 x86_64_linux:   "ae12b55177a56d27c135ef5c467c28e08b80d33c580fa017315c6e4456066974"
  end

  uses_from_macos "libxcrypt"
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
