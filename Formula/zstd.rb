class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.3.0.tar.gz"
  sha256 "0fdba643b438b7cbce700dcc0e7b3e3da6d829088c63757a5984930e2f70b348"

  bottle do
    cellar :any
    sha256 "1fa4655f669b59f70a3b415bbf61db3788398648756156000c4073172ec008b9" => :sierra
    sha256 "81ce236deea3549ca5c8fd88cea058163977ca9c209c35a0c20fa905ceab2ba6" => :el_capitan
    sha256 "35c97da893c30d9e013bdbeb2cb04a20d0262702cb32ac49390b799284beec81" => :yosemite
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
