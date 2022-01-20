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
    sha256 cellar: :any,                 arm64_monterey: "ba590597ae6a5d8b084478441af5332c94e0f3896a5d7a4be2e6f2c3be4f0df9"
    sha256 cellar: :any,                 arm64_big_sur:  "e49cf4084f3c9e60480d0d77cb73f760fdf2b5735fb2c12a45de3c687995aa57"
    sha256 cellar: :any,                 monterey:       "13190f9cfc7db924880c529ca5ae1867c0b7ed9a319463c5b95bd304fe12a547"
    sha256 cellar: :any,                 big_sur:        "5c1d562b1ee8087e3ecdd04134a8db4040a13190e42b1408c7aede140af3dace"
    sha256 cellar: :any,                 catalina:       "5b7a906469cb69b94e6e1e16839646cf7624e7ba94b41fe65fc852d4632ccccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f0d265612b10caf5533a0b0f6beba083504557aca269c4e2ab7e90cc8e355a"
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
