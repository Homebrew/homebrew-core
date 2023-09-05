class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.10.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.10.tar.gz"
  sha256 "13475c0fbeb74139d33ed793bf00ffbbb2ac2dc9fb1d44467a410760aba36664"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4bbb3367f6c6af71edf5a5641c6894163f952608edcd890dc28d0a287bd48e82"
    sha256 arm64_monterey: "f8e84e581f4092cbfd9ab70e9c0ef440fa0131f6d2ce829893418d6c31921c48"
    sha256 arm64_big_sur:  "d0b83178659e7814bd3036d4f2a8d7865737e824077ac6ee1541f99441421f77"
    sha256 ventura:        "98a9ca7f60d55965f3dd2411dc09de589ae92cb363e5e8d02472462ea3cc16f1"
    sha256 monterey:       "f13ff3572f74a530649ed7c7f36cf8d7300909c8cde15d2420b258231d32a815"
    sha256 big_sur:        "37f26023ca44b001e87af83e25df6c5f8e9b5d1c838a58eec41308e5962eb5a9"
    sha256 x86_64_linux:   "8624c4c405b1c492fcca7a4f6a3bb2f053b4784add7b4fd0a8025634f307542c"
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
