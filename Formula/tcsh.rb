class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.23.02.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.23.02.tar.gz"
  sha256 "c03f80405136731b3091da735a81cdd848008510324ab325f235aff709e446eb"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a01e14e6ab82a7f0172b4efdd6382981aeaf32ba7c7c9fa30357d34acd23b52b"
    sha256 arm64_big_sur:  "3c579927b9a7922a93891c60ddd27e534cf6209ff86ca6e216a61347635d1652"
    sha256 monterey:       "4607119ab2a51dc3ef55bff4515054b9ec67839d5948efa54084a1548e5996c2"
    sha256 big_sur:        "abbcce6bd543d058357ad15922fad064a60515bb70bd6e25310af0ac4d570d98"
    sha256 catalina:       "1eacbca31f5f3e0df3e43c666984ea426e739a422136cc34fcb9c503f011bd18"
    sha256 x86_64_linux:   "85121d826461baa3ef2fc1719e9430c8117f5a960628fb0f000b247859b4c11f"
  end

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
