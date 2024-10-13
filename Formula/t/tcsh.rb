class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.13.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.13.tar.gz"
  sha256 "1e927d52e9c85d162bf985f24d13c6ccede9beb880d86fec492ed15480a5c71a"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "0ceaf5267bed3efc85efcedebe5e32a5c83fe675c4b03eb0681882efea27de11"
    sha256 arm64_sonoma:   "b21a9a41ce1df413301c79c0cd433134cfa384c45270f1aca43170e81982cce3"
    sha256 arm64_ventura:  "f731e3a53d88baaefbdc5bbac669b55d2895ab6259d7f63d922d566e8b25dc42"
    sha256 arm64_monterey: "787dcae47ce234cdd6f3df70b6458ea955e73f936acbb53e0e9083464a109b17"
    sha256 sonoma:         "73262bdc3403940827207e5834f2bca3dc8524d9901e334fa05d7c6fa718d9a9"
    sha256 ventura:        "e746ac1cd27292e67bb0596abc2d22ac281b6ffda20abd0853759faf0080fa52"
    sha256 monterey:       "a4691a92634ca8ee1b37a0176b22f46bdbeda5737fb1817f7dcbd5be11457103"
    sha256 x86_64_linux:   "5ba8ae414fef90bbe832539c0fb69041a2106492d07c41c7d26d1ff98b9c50d1"
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
