class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.1.2.tar.gz"
  sha256 "980b8febb0118e22f6ed70d23b5b3e600995dbf7489c1f6d6122c1411cdda8d8"

  bottle do
    cellar :any
    sha256 "75e578a6e1435726aa0e3fc5c69d1216c818701c8b21eca1dbb8743d922c610c" => :sierra
    sha256 "2c1668a42abb7a6cd5140905245db1c9ed07c6ef07a11f02eefa7b9d3a85f717" => :el_capitan
    sha256 "edbbc109d7b28b8174d3ad95f31b34d30ff8b08312cee748c5102413d4e5ef52" => :yosemite
  end

  option "without-pzstd", "Build without parallel (de-)compression tool"

  depends_on "cmake" => :build

  # https://github.com/facebook/zstd/pull/497
  patch do
    url "https://github.com/facebook/zstd/pull/497.patch"
    sha256 "2bf9d85a083af66da3323f43b815fe41e21ebdab126dbbbe4d1e5f47d2e05036"
  end

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
