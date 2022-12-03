class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.03.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.03.tar.gz"
  sha256 "7368bfdfa6d0c8b0040d47c00b3dfc17b501e3bc032d05ce816019aa825798f5"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ea9da55b46eaf978247aad58f0051526c0d5ca808eb3b67cfd4cf4f0fe7f40cd"
    sha256 arm64_monterey: "2fdc5b2fb9d5b820d155169b50ef281acdc07e0a12024187c506d676c20f4059"
    sha256 arm64_big_sur:  "b595809dbd7e033cb5fb9aa63a6d482fcc059fd501e2b6e9d1d2734bd6dbd81c"
    sha256 ventura:        "cd231f885d07918c409e5a52f059668032ace05dc4c6b22bf99982daf7693c78"
    sha256 monterey:       "b9b3b26b60c854d7de4e2454358610310e526a54d9faa74f8ddb7c9c551fba18"
    sha256 big_sur:        "869c57feeb8ccd0ad58fcb9f2a08ef6e6794dcac8b027944dc576547828f365e"
    sha256 catalina:       "f93d55cd42f92fda08961f16acac43290c59b135a87e742d47b355e62c6d5446"
    sha256 x86_64_linux:   "421f994d353042c5d2ae1815b3a7565636a9c05b2ea183648aa8f1d6a57715a8"
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
