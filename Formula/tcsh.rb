class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.01.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.01.tar.gz"
  sha256 "5659a1b973b1f947e36238cb17a00210ac4cff3b496f8f851acd77172ab91d7e"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0f79c59227eb84c2504946ef28782ed98f7c1162af5b3edb95252e9cb860d9f4"
    sha256 arm64_big_sur:  "0fc3bc6e356efc0b17d8a0ca32dd6c2ea69c85cef66c0c33d17a0a02b6ab80ef"
    sha256 monterey:       "228d4cecd20d1a228652c53fb0116014341823d1b40528076e1a4a3c9c592a19"
    sha256 big_sur:        "3cd1f6b636decc9ccb96c4185b9ec1ed30c43922cf7088f79c93dc082dfc345c"
    sha256 catalina:       "9966998dd43efb22997460ae8d83b1c3e9f3488dde47afb81c46fcd64f974bec"
    sha256 x86_64_linux:   "4d2662db222e8b7d6c6e66f748564a1eb4a854cc7b71bed0d0968d82991f6336"
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
