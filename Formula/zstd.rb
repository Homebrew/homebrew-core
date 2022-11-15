class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.5.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.2.tar.gz"
  sha256 "f7de13462f7a82c29ab865820149e778cbfe01087b3a55b5332707abf9db4a6e"
  license "BSD-3-Clause"
  head "https://github.com/facebook/zstd.git", branch: "dev"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "92f953ed8a8c77b9e282d7cb6a6288d77e6f40bb1b3eec78e2fbbae29c12b220"
    sha256 cellar: :any,                 arm64_monterey: "844b957a277cd93f70f8de91bd4caa21579f9b9e2f55bd5daf0334eee8ef1196"
    sha256 cellar: :any,                 arm64_big_sur:  "091743749cec2f0ae34482ae370aa5a563d6c7841c42fbc25e0d061863f5faa5"
    sha256 cellar: :any,                 ventura:        "40b665d1ad7b73e24e15d2cc7e49629c7bda5a40e947a3e4106935100a189828"
    sha256 cellar: :any,                 monterey:       "b0eabfa556c5aed039a5b22cd7e2e3dd52c7d2416c1141e4a8e9e825b9238fc3"
    sha256 cellar: :any,                 big_sur:        "585bced60a658bfbda88d6a500fa26671871aa354f65cef767f17ea46209b4f2"
    sha256 cellar: :any,                 catalina:       "bdd2d3349fbcaa7e299cb6184f43e7f2bf29bd5936396d4c7c3d132bd687cd15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "006b5ab6a4616a8b6f59953cb9efb546d312e3ba231c303bb56749e7f66f56df"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "xz"
  uses_from_macos "zlib"

  def install
    # Legacy support is the default after
    # https://github.com/facebook/zstd/commit/db104f6e839cbef94df4df8268b5fecb58471274
    # Set it to `ON` to be explicit about the configuration.
    system "cmake", "-S", "build/cmake", "-B", "builddir",
                    "-DZSTD_PROGRAMS_LINK_SHARED=ON", # link `zstd` to `libzstd`
                    "-DZSTD_BUILD_CONTRIB=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DZSTD_LEGACY_SUPPORT=ON",
                    "-DZSTD_ZLIB_SUPPORT=ON",
                    "-DZSTD_LZMA_SUPPORT=ON",
                    "-DZSTD_LZ4_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    [bin/"zstd", bin/"pzstd", "xz", "lz4", "gzip"].each do |prog|
      data = "Hello, #{prog}"
      assert_equal data, pipe_output("#{bin}/zstd -d", pipe_output(prog, data))
      if prog.to_s.end_with?("zstd")
        # `pzstd` can only decompress zstd-compressed data.
        assert_equal data, pipe_output("#{bin}/pzstd -d", pipe_output(prog, data))
      else
        assert_equal data, pipe_output("#{prog} -d", pipe_output("#{bin}/zstd --format=#{prog}", data))
      end
    end
  end
end
