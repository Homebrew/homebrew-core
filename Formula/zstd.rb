class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.1.4.tar.gz"
  sha256 "6aae2b586e359344cb8ecfe6917a407dc7e01b5d7d7388559714de37900fb9fb"

  bottle do
    cellar :any
    sha256 "be320874eae5377dcf9c81c06b06a91424e15e991832abf64496f4bb942c020a" => :sierra
    sha256 "2b5df17e2e7e00dfd8d3751d450fcd2d73f64d58ef13acaac74e9f94f1a9cec4" => :el_capitan
    sha256 "0d9342bbd0a18ddce382181ca17359d2ae8f863d379a0dd8b2ef966d26755493" => :yosemite
  end

  option "without-pzstd", "Build without parallel (de-)compression tool"

  depends_on "cmake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    if build.with? "pzstd"
      system "make", "-C", "contrib/pzstd", "googletest"
      system "make", "-C", "contrib/pzstd", "PREFIX=#{prefix}"
      bin.install "contrib/pzstd/pzstd"
    end
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    if build.with? "pzstd"
      assert_equal "hello\n",
        pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
    end
  end
end
