class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.1.0.tar.gz"
  sha256 "61cbbd28ff78f658f0564c2ccc206ac1ac6abe7f2c65c9afdca74584a104ea51"

  bottle do
    cellar :any
    sha256 "4f39a55c4825416dc781d76c1d074b0c94123a2776bd228210482007242dac97" => :sierra
    sha256 "44ad087ed45c645534cb7f50fd11d0a5a6c108dbd55cd3b87611a391f1468170" => :el_capitan
    sha256 "0496df2283965e4bd5a9cef51a48ab46145b0b98901a55b7300630c49f3e68b8" => :yosemite
    sha256 "d0acff7aaa610d58ead02729ad5ec2a447c764da12c2ffce79af8ee1c9effcbe" => :mavericks
  end

  option "without-pzstd", "Build without parallel (de-)compression tool"

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    if build.with? "pzstd"
      system "make", "-C", "contrib/pzstd/", "PREFIX=#{prefix}/"
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
