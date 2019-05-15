class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.0.tar.gz"
  sha256 "63be339137d2b683c6d19a9e34f4fb684790e864fee13c7dd40e197a64c705c1"

  bottle do
    cellar :any
    sha256 "f145b299d71c80ab6735068ec7778e4279e962feb237ac209a1efe7179031675" => :mojave
    sha256 "e9a4a972348ab974856859698ce3e9e46c770ec81d06e978fadee4e09a9ad50a" => :high_sierra
    sha256 "3891d16d5e3a80d3263821d3b627b45b650cbe14c3c7b4e9c511e2f9b4a2768b" => :sierra
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
