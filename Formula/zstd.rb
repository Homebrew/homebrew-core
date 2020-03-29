class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.4.tar.gz"
  sha256 "a364f5162c7d1a455cc915e8e3cf5f4bd8b75d09bc0f53965b0c9ca1383c52c8"

  bottle do
    cellar :any
    sha256 "31e79477416c7e8d44ca7e2339167a1892daea4885b95503b7bc316cae5159af" => :catalina
    sha256 "8533ca2bb803f88c0bddb7131de1fff6fe8f0c6278982ef7cb0332631010291c" => :mojave
    sha256 "63fd4c9d7326960a5c395da10b323a4d285cce7a7eb6a89e7e47b591a7fb72d8" => :high_sierra
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

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
