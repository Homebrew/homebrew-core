class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.00.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.00.tar.gz"
  sha256 "60be2c504bd8f1fa6e424b1956495d7e7ced52a2ac94db5fd27f4b6bfc8f74f0"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c8b0e8fd0288a59f3bad4c354c3e961f2e67ed7619c9a562e62bd0fc8cf08871"
    sha256 arm64_big_sur:  "8c6d21af42f2626158fd308f1b7a4be87abc706f646d7a96f7d2af4f40f04772"
    sha256 monterey:       "6da23cfbc2409cc4ef46f431eb9904f0664228c023bb477ec12d2afa653e17c5"
    sha256 big_sur:        "94167b5ecd50ab3180589d3103563835c40145dfa941a43e559d82a3a14ef232"
    sha256 catalina:       "7fc485b775333252b7f1e387e765a3da1ed3c1f50e5b1d4fd7849eed9c1d8dd4"
    sha256 x86_64_linux:   "712dd61b6a9c9c8290009089f73762c194a612ed3cad55e71e677db63db16556"
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
