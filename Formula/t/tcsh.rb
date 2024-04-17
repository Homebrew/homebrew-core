class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.12.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.12.tar.gz"
  sha256 "e3270ce9667fd5bd2a046687659fcf5fd6a6781326f806ebd724f1e1c9cd4185"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "32241edf1fddce3698aa95a57c80da925a70c8d6f107cea3d80303599968bdfe"
    sha256 arm64_ventura:  "92f0b3fbd2e10d6a363744821bd40300bba6730ddcf67f32767253a57618e6a5"
    sha256 arm64_monterey: "a4c8d5b777b1a9ef3c7fc5eb527e97a37051598ee7045fae972d9d459b8db0f5"
    sha256 sonoma:         "aa4ccb6e90c180903130547e393faa5f03f35686e847eac79f9fe29feca3abe7"
    sha256 ventura:        "e36497212153cfaac0face18734358dac55669245bd202829a53e62c0ff3203b"
    sha256 monterey:       "b8f20676d4a993414b70f0e9997e6a64af1c7ec66f2342e68a22386cfd216390"
    sha256 x86_64_linux:   "5ccfc8a411b6db3a932bf0dd6edddc913144022209fe290d731622543b3013a4"
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
