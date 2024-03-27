class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/refs/tags/v1.5.6.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.6.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.6.tar.gz"
  sha256 "30f35f71c1203369dc979ecde0400ffea93c27391bfd2ac5a9715d2173d92ff7"
  license "BSD-3-Clause"
  head "https://github.com/facebook/zstd.git", branch: "dev"

  # The upstream repository contains old, one-off tags (5.5.5, 6.6.6) that are
  # higher than current versions, so we check the "latest" release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "4712aabcc9f2710c0de2597aa9675ba95cd81fb59e27e8973b09a6ca5eabc2e6"
    sha256 cellar: :any,                 arm64_ventura:  "cd3a7447c6a18cae189c2366820113f7b23425643482f8af45d03c6e91417ff8"
    sha256 cellar: :any,                 arm64_monterey: "f41cab61bfe2815d4ca18fa072c507ab9f9c10a8a532c8a660b1ab0f94e9bc8f"
    sha256 cellar: :any,                 arm64_big_sur:  "4189e80e2dc006e79f08b8e7588773cbd93defbe908c9adf85aa666ee2911f98"
    sha256 cellar: :any,                 sonoma:         "2137fe12a266078c16b162342500c7efa263def709e6742bfb4bf8601a3f36af"
    sha256 cellar: :any,                 ventura:        "f74c7a0b93a218a15987716188f71c264cd9a0a54563636f8619ff803310a8ce"
    sha256 cellar: :any,                 monterey:       "0d57c7e4a47355acffa02ed92ee98e5df7dd3dca0147b9697661330293e362af"
    sha256 cellar: :any,                 big_sur:        "23c726bf4b71f74ac69bd4a6b67541b08c245f5b3ed6630c7ab914082655457c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96afcbd191c9961446161a6fabf09cbbb4c6b3df371cee25b71c2c5d611719a2"
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
                    "-DCMAKE_CXX_STANDARD=11",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"

    # Prevent dependents from relying on fragile Cellar paths.
    # https://github.com/ocaml/ocaml/issues/12431
    inreplace lib/"pkgconfig/libzstd.pc", prefix, opt_prefix
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
