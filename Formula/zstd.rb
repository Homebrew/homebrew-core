class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.9.tar.gz"
  sha256 "acf714d98e3db7b876e5b540cbf6dee298f60eb3c0723104f6d3f065cd60d6a8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "beddf3a858da5063f7a407e5c78c0c83a2efd2595354acb750118da7d87f0974"
    sha256 cellar: :any, big_sur:       "34a6c2cc25d1a7bca6e2294ec3d024f359a2aaf705798b9cbdd71bccdd5c08bd"
    sha256 cellar: :any, catalina:      "d3f7b4d61e213d3fae27317d496251768ad8cfe03a4aa1ab11479c632a7e4050"
    sha256 cellar: :any, mojave:        "685d57a5577f21f89d5ee20aa986c447adf315bcf4daf96d22cb5cf170e4a5ce"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    # Build parallel version
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
