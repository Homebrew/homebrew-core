class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.8.tar.gz"
  sha256 "f176f0626cb797022fbf257c3c644d71c1c747bb74c32201f9203654da35e9fa"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "d015379ee322c5984c55803256ac876ed1389eca2c15767b251232a81f45b08b" => :big_sur
    sha256 "d3810a086fabf6504862103baf4026bac4c47fa185b748b319106c8bd0fd9e3c" => :arm64_big_sur
    sha256 "ad897f36994db64c4ec410c1e9324b66dcf4f2175cf7d24c62ec647921b5dc7d" => :catalina
    sha256 "936b64748f097bf20c380f06ea3d8dc963e6051240d92935b36776546c406ade" => :mojave
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
