class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://web.archive.org/web/20170609182511/www.tcsh.org/Home"
  url "ftp://ftp.astron.com/pub/tcsh/tcsh-6.20.00.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.20.00.tar.gz"
  sha256 "b89de7064ab54dac454a266cfe5d8bf66940cb5ed048d0c30674ea62e7ecef9d"

  bottle do
    sha256 "26605931ba06f06560ff0efbbec205d80a8129eee50b5106cf508d3f2ad08f65" => :mojave
    sha256 "7a37ce9d651ee573cfd079ef0743089ddd4929817827296972b41f8af74158bd" => :high_sierra
    sha256 "3a59ccfdab60133b8854d528465882a3a8aaaa874f70ef1e4a0deee2f06802c6" => :sierra
    sha256 "d43bbcefe883ba5bd0dc998e5c4e6e9afcd35bacc780864fdcfe5a560002d7d1" => :el_capitan
    sha256 "ecbd811718e22c579434568185a8ea87d78d420c251913f84da8093f61d1b408" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
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
