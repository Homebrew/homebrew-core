class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "2c23e848f154015242040313ad640c70e50c394385f1399d1b924029f6038286"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "070fd026f0d4f3f94df6867046dc7573dc95f3fd9d1b06127405042bf4828c6a"
    sha256 cellar: :any, big_sur:       "9a9360d451e0adb99ec2c03fdae6031ed4607149c6356af3b1d7f62e38bade62"
    sha256 cellar: :any, catalina:      "c157512eabb27911cf687b3064c7443e3b0bbecfa35022c27982a8ca786af7e1"
    sha256 cellar: :any, mojave:        "f1e67214ceb74c8e44989f93db03a43e74fbfd665ce11b4c6c33e5640d87cad9"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_TESTING=OFF"
      system "make"
      system "make", "install"
    end
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
    system "./test"
  end
end
