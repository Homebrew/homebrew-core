class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/releases/download/v1.3.7/zstd-1.3.7.tar.gz"
  sha256 "3277f236df0ca6edae01ae84e865470000c5a3484588fd5bc3d869877fd3573d"

  bottle do
    cellar :any
    sha256 "cc1d097045f464b4953015edb57235fe48cb8dc887ec1d21e29599c95c8de178" => :mojave
    sha256 "47a2cde8ba8a738e085c5be33ead12e00eb3ddf71f8017cd6023e3ad3434faf0" => :high_sierra
    sha256 "05a81230aee7d4128d96bc090b4c0c9914aeb3cdf668621a7d257577876c2ab7" => :sierra
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
