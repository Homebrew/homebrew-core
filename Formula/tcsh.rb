class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "http://www.tcsh.org/"
  url "ftp://ftp.astron.com/pub/tcsh/tcsh-6.20.00.tar.gz"
  mirror "http://ftp.funet.fi/pub/mirrors/ftp.astron.com/pub/tcsh/tcsh-6.20.00.tar.gz"
  sha256 "b89de7064ab54dac454a266cfe5d8bf66940cb5ed048d0c30674ea62e7ecef9d"

  bottle do
    sha256 "0ef20f94a3d60fdd22a9cbeebb5474d04d5a95fbfeb60e5de51e3fa102d94913" => :sierra
    sha256 "dd05f0d9c6c12520c5b20fd0505288877a79a2b380091261490f659f6a81aadd" => :el_capitan
    sha256 "2d3fed239e9d5ac71b47c3e5bf96b93c1e9ba77c3799ca482a5b6809621d5f1e" => :yosemite
    sha256 "ff5b980d71cb0f151264f0a7f6c6b34120e2420aac284ecfe8fcf908f4e90c07" => :mavericks
    sha256 "beab7a774551d3b446526359c31900fbbc7300403b545395c1949ba302a65e24" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"test.csh").write <<-EOS.undent
      #!#{bin}/tcsh -f
      set ARRAY=( "t" "e" "s" "t" )
      foreach i ( `seq $#ARRAY` )
        echo -n $ARRAY[$i]
      end
    EOS
    assert_equal "test", shell_output("#{bin}/tcsh ./test.csh")
  end
end
