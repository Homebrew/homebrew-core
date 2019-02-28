class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/releases/download/v1.3.8/zstd-1.3.8.tar.gz"
  sha256 "293fa004dfacfbe90b42660c474920ff27093e3fb6c99f7b76e6083b21d6d48e"

  bottle do
    cellar :any
    sha256 "da2c2195b3b37a3a769005ad008e82c9a77813cde7a08ea6bc125c237aaea735" => :mojave
    sha256 "b8130708753504c0f4e390021c9b6d6c659a286307b8cc2443029db975fda7d7" => :high_sierra
    sha256 "4405983483a8257085a1eac35a08de27f1f71a23e66f65e0047723c0cd776852" => :sierra
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
