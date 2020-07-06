class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-4.2.3.tar.gz"
  sha256 "78c781ce2c3783b85d894e29005b7e98fc246b33f94616047de3bb4d11d4d823"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "028d07a97370b37fc28a2f2045bf3e4a9241d9c49f5eea2e635960ced7b6453c" => :catalina
    sha256 "a16a370f4bd6d2acd415f305fb99b2bfba1b86f666c68877d01bd90ddcb7522b" => :mojave
    sha256 "29602aec2851811108e97397e6310f091f5e5fe0844f9cfcd6657193d9c53ff4" => :high_sierra
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
