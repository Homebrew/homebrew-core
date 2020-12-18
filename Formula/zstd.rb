class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.7.tar.gz"
  sha256 "085500c8d0b9c83afbc1dc0d8b4889336ad019eba930c5d6a9c6c86c20c769c8"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "c63e0f718a982cd54363e6ceff21928b579c062e7efbcc41316f31c608f449b5" => :big_sur
    sha256 "e767a1ae6f1508ccaaaaf8375ce266d8ce955500f7d8aa1715176449cb6fa89c" => :catalina
    sha256 "1dd32be9ba8c0281996b4ee75e04deec3b35ee7f71abba46195c0f3840bba1a0" => :mojave
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
