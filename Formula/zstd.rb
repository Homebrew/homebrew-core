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
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "c7084442d57331eb75dc51926bdbaab33c31059587a1626c714be87c1c43df49"
    sha256 cellar: :any,                 arm64_big_sur:  "f4be0a469b31cebf7a44d4602d1f31303a211405ce566b6ce1a8743093603b3d"
    sha256 cellar: :any,                 monterey:       "3cd1dc42736c2873b0684f0da4ffe3e9fdac30ec9ed5b4c0f9f657bc0d5c3f50"
    sha256 cellar: :any,                 big_sur:        "c79db7b0ca3d67b1094221c062a74e504aeddf2e8df782c01bc551a16794f73f"
    sha256 cellar: :any,                 catalina:       "bb4069e2e9d4eb1bfe3c8b4e4c7d4fdedb689b48f46a7ab008591aa7230b765f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b612ded8e47a6049f2645d2de06aa74a3a6d47b3c6d8cb166a008cbe808e9bc6"
  end

  depends_on "cmake" => :build

  def install
    # Legacy support is the default after
    # https://github.com/facebook/zstd/commit/db104f6e839cbef94df4df8268b5fecb58471274
    # Set it to `ON` to be explicit about the configuration.
    system "cmake", "-S", "build/cmake", "-B", "builddir",
                    "-DZSTD_PROGRAMS_LINK_SHARED=ON", # link `zstd` to `libzstd`
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
