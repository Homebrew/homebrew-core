class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/releases/download/v1.3.6/zstd-1.3.6.tar.gz"
  sha256 "e832a0c01ea033e2df1f346ac6976d8cf8f9db6416151ba4fc2cae2ac3584594"

  bottle do
    cellar :any
    sha256 "0e039b99aa28044067d0d4eb609cdcecbb64215d04a7ce6ab7c04e8d9921183a" => :mojave
    sha256 "85584f4a814eb5b29942ba9592416bbb042df83394cf413140109470431bd729" => :high_sierra
    sha256 "59af401ee0f9bf3cae57e4f035f1d7f62b7fdc44f34ccd384c343dc0a68c8ff6" => :sierra
    sha256 "ce6df98dc4ebb218c5189cd5e30fa46c665f4917843a75935d0b9adf9a1baf86" => :el_capitan
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
