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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "7255929473878bace1be37dd11537574277c29145eb0ad9bef47de3c397682b5"
    sha256 cellar: :any,                 arm64_big_sur:  "255092e3053db5b02bc10546614929cdaac224425380f734d0fa70100a4de4cf"
    sha256 cellar: :any,                 monterey:       "fd647e112806b8a9184f00ad9838de77430d6fe10bd22868db3ad75f3418c20b"
    sha256 cellar: :any,                 big_sur:        "8611aeb5d57f133a633a638debbd059c3efee253c327615768ce08fd10add20d"
    sha256 cellar: :any,                 catalina:       "bf1cdb599aeef3296cc0558642672e025de9fd0f3488c61fec93bdf8211dd13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e0d0c897f92badb88cd292076c1be7293325b3d0f5ee9430b1ad574bf0519a"
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
