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
    sha256 cellar: :any,                 arm64_ventura:  "0d9bceb9cfaeab8f5bf8d1a199b3c241c72dfee55c3e3fd9b2b34114570c3401"
    sha256 cellar: :any,                 arm64_monterey: "6de68b55a5336e68071b587756944e5138334760f594d3c84f036c0558a06019"
    sha256 cellar: :any,                 arm64_big_sur:  "dc078a0e82e3cfe82e7b3aa05d3cdfcf9d450e0db8300203247962c45e453bee"
    sha256 cellar: :any,                 ventura:        "7af6b7ea795672d8db6059c9491f8b6a973d376be21b5bd5ce98022e7870c03a"
    sha256 cellar: :any,                 monterey:       "833ef75fe78b4c27e29fc7abaa4a5ee962b622ffa4c1de5e02ef4fff13394e3e"
    sha256 cellar: :any,                 big_sur:        "0e425c420f3a24a3b5e1cd932e01855b1945465467c0cf0a5f25e9d98b46ef75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe565b3d44fc25338174bc25efaacf02581c6f6128211d9f7d175aabf2a7973f"
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
