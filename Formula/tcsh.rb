class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.06.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.06.tar.gz"
  sha256 "a8cd0cd1ddc94f870681ccbd09a3511050e9a71e5fe99a2b007941f5e1b2b7a5"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "868960bee915713f2338f3245d2f64abf728dd3c766e92c311a22be0033b0b47"
    sha256 arm64_monterey: "2827874f18e630d9694b3fdae7746b960b7c49b52630e0a774ae51949e341eb9"
    sha256 arm64_big_sur:  "3b2f347b133c8efef6fd8c4af1fe2072b6e4707586f6892ca2e7e1fd93deb31f"
    sha256 ventura:        "ea2c62f3b4657fe97aa9ad000af94e3e1097293ed9967d118f215a0ef2f189e9"
    sha256 monterey:       "aff12abea16419157d7e8e844a53f7c6cda5f6d8205c753857f892636b16f792"
    sha256 big_sur:        "29b47952a962ff107c5aae4e9f58840b8860a886fcda6e3c6dbe47915e42951f"
    sha256 x86_64_linux:   "e2a406d659ad9363457a226c7d01c6c0f30e4a62cda5d73a6eb10d538ac1571b"
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
