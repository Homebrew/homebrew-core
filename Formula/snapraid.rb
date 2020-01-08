class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.3/snapraid-11.3.tar.gz"
  sha256 "d35ad92157936db3411e2cf7325665fc59e2d159204f9424895cfa9f33122af1"

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
