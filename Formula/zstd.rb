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
    sha256 cellar: :any,                 arm64_monterey: "dea9b5e2d3ca1c6aec6a1fadefeb615115c6cf6fb8482e9addb9ed23691c6ce7"
    sha256 cellar: :any,                 arm64_big_sur:  "17089f121b426d5eccbf42e7f420227a4eec3a7f8915074c399e4af76f53cd84"
    sha256 cellar: :any,                 monterey:       "92089ac665de71072f944a106df3f2ab510470c5ee9dafe3a223ee6dfab8b707"
    sha256 cellar: :any,                 big_sur:        "7a86804ef138928d6a5faed965ac23b3c0d9609231ff6f5e0a4702cc0b322a5c"
    sha256 cellar: :any,                 catalina:       "e5e739bbf409053a990217d7a61a01a172a1cc471068817707b987ef72ce28f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61bb93ed3485d643f87f86817dbed7c3922ecc0eedc74635b3db3b29e7dfdabe"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    # Legacy support is the default after
    # https://github.com/facebook/zstd/commit/db104f6e839cbef94df4df8268b5fecb58471274
    # Set it to `ON` to be explicit about the configuration.
    system "cmake", "-S", "build/cmake", "-B", "builddir",
                    "-DZSTD_BUILD_CONTRIB=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DZSTD_LEGACY_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
