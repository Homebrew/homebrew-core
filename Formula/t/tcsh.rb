class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.15.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.15.tar.gz"
  sha256 "d4d0b2a4df320f57a518e44c359ef36bbcf85d64f5146d0cb8ff34984e0d23fd"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2cbe0bdd46defee1ad3ff4c5e8d3088e1d774d82d9f789f6d8e9f71541e1a325"
    sha256 arm64_sonoma:  "2bd1839f9539304030031297aea14002847bac05fbfdd6b40daba0e046da9011"
    sha256 arm64_ventura: "c616a15a27d0a6405039006e645b602a146c5dfba372e8e586de3352e5668d36"
    sha256 sonoma:        "ddd888de4c89d208ab867ce6ccb3a190aa1ace13bfd678b93eeefe1858ab6206"
    sha256 ventura:       "f4434873a4a37fbe06aa64e90512021171b9a6728b1411cbe0f0b5f9e2f7d6bb"
    sha256 arm64_linux:   "260453a0e766152ddc609767d7d12328a6b76b9b25d5f54532b2140d70716535"
    sha256 x86_64_linux:  "3b1b397961ac020ec12a78df1b9c4401f1f8ca16cfcb59cc6d99c51c475c0c61"
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
