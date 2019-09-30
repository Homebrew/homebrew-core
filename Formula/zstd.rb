class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.3.tar.gz"
  sha256 "5eda3502ecc285c3c92ee0cc8cd002234dee39d539b3f692997a0e80de1d33de"

  bottle do
    cellar :any
    sha256 "8ecb601e142f8fc566885328bfff0398006897ede8ba795fd2ef9bddc501a480" => :catalina
    sha256 "ecfc64c865ec7e545a1f51b6d5c666bdb4d61299966fdfa7bad5de6a3b8e2fc4" => :mojave
    sha256 "a65a50d505c628c2e6c411c8b142ace19a99a27000ad15ff17ced1c1f80454d1" => :high_sierra
    sha256 "4ac25ad9f54a66e460ba513c0fb06476ec8d66821e2e149f1d4e805512b97e62" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    # Build parallel version
    system "make", "-C", "contrib/pzstd", "googletest"
    system "make", "-C", "contrib/pzstd", "PREFIX=#{prefix}"
    bin.install "contrib/pzstd/pzstd"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
