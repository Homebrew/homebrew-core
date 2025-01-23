class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.14.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.14.tar.gz"
  sha256 "36880f258a63fc11fe72a65098b585ebc4ecdee24388b8ebec97e6ae8e485318"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b460d7025a11e390417b99856092d9910efa2f782860ec2eac1b69818fc80ff8"
    sha256 arm64_sonoma:  "298251e43c80d546516f9b428c63b691f3b6d19dfae15153ef599ef493eb17d9"
    sha256 arm64_ventura: "83aa4593aeb551300ac7a23dd246c7b7fea918fcfd84bba5ab01ec7612a6f2c7"
    sha256 sonoma:        "4f15dd7ac8b3da7915f7f797a68223540f5f5f525c70f0cc800aa17ae6f6c398"
    sha256 ventura:       "2bebcbc5a02fa991f1a9a46e347f2528af16813787ff302097095d5aafd7bee0"
    sha256 x86_64_linux:  "110669eac6b4e5a1c8fe4e0dcb87e06928e77c938c5ed97fbf3e10eaa7df01fb"
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
