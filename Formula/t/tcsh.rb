class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.11.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.11.tar.gz"
  sha256 "b5a7b627abb3ef2e8d3a869bb675d0e927d850704447a1b2c77946c0d324799d"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7dd9db8b5098e31ea6271ac6d5fdbb5b419dfede50815cade2304853d139ec53"
    sha256 arm64_ventura:  "18290379c1442683693bce4b1c3563b151b3e88ac9ffee0d7ba4fea0a2d785e0"
    sha256 arm64_monterey: "f041614235fd35c2093dfb0666a54278fba994e6c275a7d9e5015ffe13af9430"
    sha256 sonoma:         "59c603a9d725dbb7e1e149ad0f56670ef6f9c08d7756dd295f95ccac3c24f172"
    sha256 ventura:        "b5d4b809de1fc0aa3672fe3b61b438428c6717f841afb9da17a927563495f9d5"
    sha256 monterey:       "b45fe6502f686a33c7b38b7aa78867a99cb3effb4bcdca2ac0551d3f0c82a178"
    sha256 x86_64_linux:   "47a214211a1903266d80a31e80fde193c810bf25b014dccc406bce0bb24e883b"
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
