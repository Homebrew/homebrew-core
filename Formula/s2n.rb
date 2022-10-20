class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.24.tar.gz"
  sha256 "df6d2642e7b491f56110527bd73686d94ed3b186ff78d24e525cc0c3dd0d6b4b"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1765a695328b72fa0361713a2ddbb26b0cdf1886df932709e4569d7603784f9"
    sha256 cellar: :any,                 arm64_big_sur:  "663abb169a3322b1865ffebab85c7d80fea43e630167cc53b23074281d5cc884"
    sha256 cellar: :any,                 monterey:       "b1918ec30570a786daabf482f2b928b534815a3adf445904bc2a83f40a26ae25"
    sha256 cellar: :any,                 big_sur:        "848030735415d028a2f3b96e4744657cc40f5c21d6ebebe8058abf78f95748cd"
    sha256 cellar: :any,                 catalina:       "3e8c25e22e7d72de803927313cc873654e6d32ce8de3d85c2d1819962d3a3085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d0822d851a8aaa163206fb30f51588b231f317c21e10b673a626a87f24975d1"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
