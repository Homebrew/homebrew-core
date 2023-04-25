class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.5.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.5.tar.gz"
  sha256 "98e9c3d949d1b924e28e01eccb7deed865eefebf25c2f21c702e5cd5b63b85e1"
  license "BSD-3-Clause"
  head "https://github.com/facebook/zstd.git", branch: "dev"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b709835f4cd5d339b97103f0dfa343489a02d2073f8e80ba7b04d682f1d29bd4"
    sha256 cellar: :any,                 arm64_monterey: "e3cb579108afe4794143b33f24b6020648ca166f0104eb3d13cee56da62c949f"
    sha256 cellar: :any,                 arm64_big_sur:  "faf929cf92dad72eca2b16fb5aedb695f5d291aac18b496061b8b14003b2e224"
    sha256 cellar: :any,                 ventura:        "e4eb8cc0473c699ec424bfecc67fcfd30631f7fe5eacf26c727bfed73dcf7c12"
    sha256 cellar: :any,                 monterey:       "9c1cfe9158a48f6bd3eeb92608ed2799a048d1d27e70e7acef82d5eb4a7a1cea"
    sha256 cellar: :any,                 big_sur:        "73d78b5fef5ba31d3c37b8201310fe042f30c6000a97b8ba0d91208e1e1de231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c8655224f058316c16462507b6cdd061bd546e161bf8419c68ca526d3a9a48"
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
