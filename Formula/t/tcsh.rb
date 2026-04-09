class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.16.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.16.tar.gz"
  sha256 "4208cf4630fb64d91d81987f854f9570a5a0e8a001a92827def37d0ed8f37364"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0df869ae003eeca37ff2acec0a8a9f604c1ffebda8b279facc0e3be826240dce"
    sha256 arm64_sequoia: "e4425a06fe4fe997de2b9e14d64707622bf7867dd6d6dc55de9f344c0ad44075"
    sha256 arm64_sonoma:  "ffa54a7ec5c1d26ce100e3abfaed1defe293003550bb173229af5c808b476090"
    sha256 arm64_ventura: "09039946701333cbde295724f9dd803219879acdf6705d1d200346cb57605f59"
    sha256 sonoma:        "487cae9b37287fb4080711e0877f76e09948b6d45ce4dfd7aa00f16fcdc7f753"
    sha256 ventura:       "c610c6f60d2cb8249d081203a842e784f3632414890481956ff126f4bf5c335c"
    sha256 arm64_linux:   "9570055136a3774880053458831d48cd936b3655b19f55f5b731481f7ae3671c"
    sha256 x86_64_linux:  "695cc9b9c3dbf80e7e088cd0803b43019ff2e5844223c5ad0553ef483a08e45e"
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
