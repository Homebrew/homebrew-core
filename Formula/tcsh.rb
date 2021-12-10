class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.23.01.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.23.01.tar.gz"
  sha256 "816c5204b9a0ee9ba88515a98af398fffd3f46fc8791943a1ff38d473055ba6d"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e47c7423c5a1f8bac8d8247dca0c94032a18a08b053f50d9d0754a9778ee6a85"
    sha256 arm64_big_sur:  "06956d228817f2f2d70e17188e7b1b8d8819ae03c6e5945611a9efdd4b270533"
    sha256 monterey:       "c95fd96b9bac7314b5e358e6b4b350523f61af3556004a5bb05256ec62f5eb7f"
    sha256 big_sur:        "7fc2dbe2c64c70e4f041925dcc8a7842f8f62684ff428a1d09c739d311a2e75f"
    sha256 catalina:       "4c37b7e1d07dea6661ae3f8d7784390d8a20852f3e2110a7f4dc8bb5e8bfd834"
    sha256 x86_64_linux:   "08962f105120620fbdd5a0c62bf1458edb8e711fd0ac507af92cd386bb326e9b"
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
