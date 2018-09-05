class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https://github.com/google/zopfli"
  url "https://github.com/google/zopfli/archive/zopfli-1.0.2.tar.gz"
  sha256 "4a570307c37172d894ec4ef93b6e8e3aacc401e78cbcc51cf85b212dbc379a55"
  head "https://github.com/google/zopfli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa3b428d9f9988230d141736882274a87e559c546e5d8b51ba00ce2f0cc23949" => :mojave
    sha256 "7e7fdea7ca5ebb6f9c4208e0d75c015d6d0ae3c715f44c3c1f326c1edb3593ff" => :high_sierra
    sha256 "a1256c4c3d2fc456ef2dff647c24dfeadf89fc99775eec17811974d633146ce9" => :sierra
    sha256 "13d19096f3489aa512003b175e3568be65b0a855ddd4cffa624e6a76290f3715" => :el_capitan
  end

  def install
    system "make", "zopfli", "zopflipng"
    bin.install "zopfli", "zopflipng"
  end

  test do
    system "#{bin}/zopfli"
    system "#{bin}/zopflipng", test_fixtures("test.png"), "#{testpath}/out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
