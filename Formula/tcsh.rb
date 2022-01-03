class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.23.02.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.23.02.tar.gz"
  sha256 "c03f80405136731b3091da735a81cdd848008510324ab325f235aff709e446eb"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cbaf3fe9888cded82e2c8375497203dd8186786acf98db736b838e9be129d4ed"
    sha256 arm64_big_sur:  "5821651b1356e16446ef60f18012daabf90d85e3bb2174d5f4ef54c2417c1ce4"
    sha256 monterey:       "05853556fc1069c79655b27b0d33494a1d5d81206279edf570ef5ba5ae49c366"
    sha256 big_sur:        "ae686d5cf9b7ceff8919b30458a438f20b2c32db38577eecb3faa82a49000c8d"
    sha256 catalina:       "61890961cd66eca02e3c149af752803f93eedbe7bf2ffb9307eac0a861d91c80"
    sha256 x86_64_linux:   "57faaeaa3d0772d2893068e3f21ebb81cedbac4dfb2e57e5d09f3db2bd4a3aa5"
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
