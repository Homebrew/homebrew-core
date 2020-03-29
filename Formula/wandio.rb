class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-4.2.2.tar.gz"
  sha256 "1196f3a4fc36cc886e71dcd13f542d3648dad989dbe53bc81ec35da19cc8fbbc"

  bottle do
    cellar :any
    sha256 "dc91ef0f03bfc027c7921a132c92ef7b9e768307050742b6ff9543998a786f6b" => :catalina
    sha256 "02cce1059503c0fa2051661ab8075e62c279aeb8a761d408ef2dd4ab7545a6b6" => :mojave
    sha256 "0dbb3e5ddd4fc6de440174d2667d8453f3f4136d6dba0d3f6cc58f15537ff9d7" => :high_sierra
    sha256 "98922801f17e30f8aa0685ba4fd2b4a21b46ab53ad1a71f7f39f28fa7cbc2186" => :sierra
  end

  def install
    system "./configure", "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-z", "9", "-Z", "gzip", "-o", "test.gz",
      test_fixtures("test.png"), test_fixtures("test.pdf")
    assert_predicate testpath/"test.gz", :exist?
  end
end
