class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/Cyan4973/zstd/archive/v0.6.2.tar.gz"
  sha256 "f80c35b2860d66299c8457b891d05277ce4e88b9bdd1f10a431e74804404cb8f"

  depends_on "make" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}/"
  end

  test do
    assert_equal "hello\n",
      shell_output("echo hello | #{bin}/zstd | #{bin}/zstd -d")
  end
end
