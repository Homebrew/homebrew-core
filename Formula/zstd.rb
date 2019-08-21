class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.1.tar.gz"
  sha256 "f91ea3397e6cc65d398e1bc0713cf2f0b0de2fb85ea9dabb1eb3e8f1b22f8d6f"

  bottle do
    cellar :any
    sha256 "4d57b86420c01afdb3b02a5838fa76bba0902dc26ca582f433278717f8637bda" => :mojave
    sha256 "c7d55e6cf66b8d697d8d9c93a03e0140a38560cde9dae6198af2deb557d4ce1e" => :high_sierra
    sha256 "18684a1e1bd85d165b4fd0c5d140512609253dbf757814580a8620bdf7e248e8" => :sierra
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
