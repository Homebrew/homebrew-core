class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.0.0.tar.gz"
  sha256 "197e6ef74da878cbf72844f38461bb18129d144fd5221b3598e973ecda6f5963"

  bottle do
    cellar :any
    sha256 "4f39a55c4825416dc781d76c1d074b0c94123a2776bd228210482007242dac97" => :sierra
    sha256 "44ad087ed45c645534cb7f50fd11d0a5a6c108dbd55cd3b87611a391f1468170" => :el_capitan
    sha256 "0496df2283965e4bd5a9cef51a48ab46145b0b98901a55b7300630c49f3e68b8" => :yosemite
    sha256 "d0acff7aaa610d58ead02729ad5ec2a447c764da12c2ffce79af8ee1c9effcbe" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)
  end
end
