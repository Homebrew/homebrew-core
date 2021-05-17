class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.5.0.tar.gz"
  sha256 "0d9ade222c64e912d6957b11c923e214e2e010a18f39bec102f572e693ba2867"
  license "BSD-3-Clause"
  head "https://github.com/facebook/zstd.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "3d51ef9a3f13e82d4dc2e3796c3f02ee32593686c87498f0ba49302b38fb5f7a"
    sha256 cellar: :any, big_sur:       "84b118224c8da97b293087196e5dabcefceaede9d0c4c60dd05bcb103d2668a6"
    sha256 cellar: :any, catalina:      "3bdec91921f43b57d2afb4fd61641dd912330c010b2c1979c51602cecfe66f1a"
    sha256 cellar: :any, mojave:        "29f6070e68f504cda74fb368ca267cf4031203371fb74cd4bdb9547229fec849"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    cd "build/cmake" do
      system "cmake", "-S", ".", "-B", "builddir",
                      "-DZSTD_BUILD_CONTRIB=ON",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      *std_cmake_args
      system "cmake", "--build", "builddir"
      system "cmake", "--install", "builddir"
    end
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
