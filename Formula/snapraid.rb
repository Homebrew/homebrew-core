class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "http://snapraid.sourceforge.net/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.0/snapraid-11.0.tar.gz"
  sha256 "30a72b8853ea750128c96784b73bb55f7faa4b16367b2e03f40c1f78515c5771"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b4ecf8fe89ab329411170c6825b6a7339f0762d097ccd9398dd66a17ab9cc0d" => :sierra
    sha256 "ffa69724c9970b59d658a9c5dafd59b2cce7180219da4960de215dd106a20001" => :el_capitan
    sha256 "4cc74d39c187216544ebb319b1ed6537198456551725b8f15e5397be687854af" => :yosemite
    sha256 "bb60bddade2e2b5cfa7df974c7d8aabc1819c00ab2a98694c87d86ed9abbf804" => :mavericks
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
