class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/releases/download/v1.3.6/zstd-1.3.6.tar.gz"
  sha256 "e832a0c01ea033e2df1f346ac6976d8cf8f9db6416151ba4fc2cae2ac3584594"

  bottle do
    cellar :any
    sha256 "1952f0a205e53619d8f8d87e1d0583857dbed930864687a2a2ca964fcb86a5d5" => :mojave
    sha256 "4db618f1cf6ef20fe6c2bddc821ac60d11f3e436645646f56abbaf008726ea2e" => :high_sierra
    sha256 "daae3ba1398b10e4bfcc3c8ebdf56e5b5519dc94b498339707484f4997ea471c" => :sierra
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
