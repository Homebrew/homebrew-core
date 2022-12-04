class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.05.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.05.tar.gz"
  sha256 "3d1ff94787859b5a4063400470251618f76bc24f8041ba7ef2c2753f782c296c"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "eb55488748a121adf4c22e202aad7d67ce49f18221ebef3339986822e2a7d098"
    sha256 arm64_monterey: "cc4be001a02ee66f0cd3f65f082cfc7f313824e5030ced400d5e61524cc47485"
    sha256 arm64_big_sur:  "1d16718fa0f8d51a1ab8eb197761188c082aedf65f01261b2034443b78dd4dfa"
    sha256 ventura:        "305289110f0d8704eefe1d376219e1fbd74e0d95ab20b7275bcfbc36f473b079"
    sha256 monterey:       "9b7d574f7bd10ee5ef8f836bdb78f1053e6e0466208aff116c04aa6280fe34f2"
    sha256 big_sur:        "67c03274974c1db2cab08b666705aa568f4e567ea094c1f20619c58d9d5c777f"
    sha256 x86_64_linux:   "7b9debb9c7eba00e241d31a005cf9dadae0a80833c975d3b83253e1ae8e47bd2"
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
