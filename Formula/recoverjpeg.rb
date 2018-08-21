class Recoverjpeg < Formula
  desc "Tool to recover JPEG images from a file system image"
  homepage "https://www.rfc1149.net/devel/recoverjpeg.html"
  url "https://www.rfc1149.net/download/recoverjpeg/recoverjpeg-2.6.2.tar.gz"
  sha256 "d7f178f24099807d80483e970de76e728da4c81c52a8293ef615d7b184f56a07"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd8deca4aaf50c470dd3ec7d385e17d99ffd28153c0ce0eeafcbc2d35da3ece6" => :mojave
    sha256 "d0e5e0183223335fee7744343ccb9287f6ddca80991f098172e0f89f5d28f10f" => :high_sierra
    sha256 "1c71c690a3d3646739ae74bdcb45d3de0845ef7874bcaf3c499499017b5f5eaf" => :sierra
    sha256 "5ecb45697e2d032031af1549df4896f42598af4aae9802b866c5c9314946a5b0" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recoverjpeg -V")
  end
end
