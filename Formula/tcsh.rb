class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.22.04.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.22.04.tar.gz"
  sha256 "eb16356243218c32f39e07258d72bf8b21e62ce94bb0e8a95e318b151397e231"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f930817db9b631c7db52a1b214c821eae5a456d199dd0a891cea7dbe26120a8b"
    sha256 big_sur:       "4c2d74ed1c5d926ad51dd171479095078db420a0d9e15615044ee6ab86186462"
    sha256 catalina:      "302f0d9d4300c8285431ffbaac65b470d5007059da22da68bffe2f1b5709872f"
    sha256 mojave:        "ccaa49f83f4a1bfac216bc86a9b2a99bd0ba2131d81322b652c584b024248be7"
    sha256 x86_64_linux:  "825ea20b88a3bd49d8b0a6164e20689f56ce63eedabd928dd785d3af90713a0b"
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
