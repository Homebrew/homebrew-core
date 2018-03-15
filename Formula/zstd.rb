class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/archive/v1.3.3.tar.gz"
  sha256 "a77c47153ee7de02626c5b2a097005786b71688be61e9fb81806a011f90b297b"

  bottle do
    cellar :any
    sha256 "f192acbf6c925141880e49918cf70a9f81a6805daab511f37a01d8b8f35bcf93" => :high_sierra
    sha256 "6bb1f29f9f011a84758bc626e203255ac49613b283f96b5a01edac38d8a8baae" => :sierra
    sha256 "0c615c0f91b014e3b627f2ac9d3653b009fa9eca9a1fdfc6f7370d89de9af6ec" => :el_capitan
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
