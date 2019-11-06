class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.21.00.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.21.00.tar.gz"
  sha256 "c438325448371f59b12a4c93bfd3f6982e6f79f8c5aef4bc83aac8f62766e972"

  bottle do
    sha256 "007aa5a816b1c18cdfc33bf949b4c60dd5e5dead253138e39cb448fdf67086d3" => :catalina
    sha256 "b5b22fe69189ad23daaba0da4997ee6ea17b21d63f2c7ef0a78f91f5a816ab16" => :mojave
    sha256 "a2497b4079f9ef60652e987b58e305627533491169a4ec348f7d967ab46787ca" => :high_sierra
    sha256 "88ee66c224517188212d05f1595c6ab3a0a16cefab8fce80f6b6a36488c274e1" => :sierra
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
