class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.9.tar.gz"
  sha256 "acf714d98e3db7b876e5b540cbf6dee298f60eb3c0723104f6d3f065cd60d6a8"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/zstd.git", branch: "dev"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1a1b9a78b09d90da95c31dbdc3d4a62ef57f2c1d875d15a62342fc1556bfba4d"
    sha256 cellar: :any, big_sur:       "eeb8825bb703294879b70a5018efecb08a42863cb56c870fdd7215d886732778"
    sha256 cellar: :any, catalina:      "9fff3447bc3ca1d239dbb239b37bd70fabd37087bf61c85407bad8d5c47a831a"
    sha256 cellar: :any, mojave:        "0da410f0a383f7068b51b0e72969496a631b8aeb46b2cbaf431989e9a8646018"
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
