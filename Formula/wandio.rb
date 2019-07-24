class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-4.2.2.tar.gz"
  sha256 "1196f3a4fc36cc886e71dcd13f542d3648dad989dbe53bc81ec35da19cc8fbbc"

  bottle do
    cellar :any
    sha256 "b93140bc27721caa21e6612e5db65aec98cc2fdd730a275470482fa500d2a15e" => :mojave
    sha256 "f096ae75294cee9c3a46121b6d304895689a10c782159b8ceb1cc159a815cc3c" => :high_sierra
    sha256 "1a534de6c950b57a640e2394f82d5b17acb8400ca010aa89a202cf9d9dc2c417" => :sierra
  end

  def install
    system "./configure", "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-z", "9", "-Z", "gzip", "-o", "test.gz", test_fixtures("test.png"), test_fixtures("test.pdf")
    assert_predicate testpath/"test.gz", :exist?
  end
end
