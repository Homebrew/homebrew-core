class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.4/snapraid-11.4.tar.gz"
  sha256 "1de47b8277c7dd9c339396efdd2b12a865ff82fdf6ab47cb945f2e21717451c9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bcd8a45d4ec8daa99fd20faddf63ec0476239b02deba34755f158cf1e629299d" => :catalina
    sha256 "44416f365e6c197fe9ba5381ef829d295cf65bbc953c666fb69a84c482c0a793" => :mojave
    sha256 "2083e11d5d72fee5bc67bb71fca4686e27f49fe7ea837e9aaea0688c53ad7dc1" => :high_sierra
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
