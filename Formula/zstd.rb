class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.1.3.tar.gz"
  sha256 "106c532ae840a6ee4aee5258f04f3acab7b3e09b9e9584ebe94e4fbfd899af0a"

  bottle do
    cellar :any
    sha256 "d580d2f02d822ba7cd5fc25183eab8ce585f2e9da54590eb0cd4fcca35ac3e24" => :sierra
    sha256 "d4a30605999fdfb4a087c17d2dc0f8dca37803faa828e5e60b39bdd82caca3c7" => :el_capitan
    sha256 "8f799ce0d821b6a3781971d520dfb9ac2142edd5a5e010a5aec61cc8dc3c6db6" => :yosemite
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
