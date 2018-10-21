class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/releases/download/v1.3.7/zstd-1.3.7.tar.gz"
  sha256 "3277f236df0ca6edae01ae84e865470000c5a3484588fd5bc3d869877fd3573d"

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
