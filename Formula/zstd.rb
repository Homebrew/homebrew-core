class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.3.2.tar.gz"
  sha256 "ac5054a3c64e6510bc1ae890d05e3d271cc33ceebc9d06ac9f08105766d2798a"

  bottle do
    cellar :any
    sha256 "f9ea1b45174bfc1e5175bc7b65d14014b4a7c685b6a5b9a6958c24db24656e6b" => :high_sierra
    sha256 "435a8e371323527702454304b105e39bd8c62a3677859f21270a638db2a3b8fa" => :sierra
    sha256 "2c9189e5f2cdc0abe0068630b6ba8d3207d90bd70c98982b3739b501db3ffde2" => :el_capitan
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
