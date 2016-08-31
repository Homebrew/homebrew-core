class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.0.0.tar.gz"
  sha256 "197e6ef74da878cbf72844f38461bb18129d144fd5221b3598e973ecda6f5963"

  bottle do
    cellar :any
    sha256 "5f8e27fbef60609f6008c39acd16b2ef087bd377fb5d538a1f2706e14e3982d1" => :el_capitan
    sha256 "ed0371ececafe64badbd77f43fd5a3bd55279cf79bfbcc0ade372a41c96f16cb" => :yosemite
    sha256 "d6eb0f4f2e26883ba03681cd40d3c140afb9954e18541b44a220522df80a4604" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)
  end
end
