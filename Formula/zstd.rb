class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/Cyan4973/zstd/archive/v0.8.0.tar.gz"
  sha256 "297ef978fd956a503de6a303f7d58714de3300f602c7cf5e4b382a82f1483051"

  bottle do
    cellar :any
    sha256 "1d7490f2ea299369b5bfe29f2bf861fbfda00116da7bdcd137a3311df592040f" => :el_capitan
    sha256 "4ab2477cb9a287fff393b89f7e7f5a9557ec6f12f6040c933ef0cd6db9a3a6f9" => :yosemite
    sha256 "6e18b2d200e79de2a5bd62b68983540edc1937683b3333a1690f9019ea54a784" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)
  end
end
