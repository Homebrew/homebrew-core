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
    sha256 cellar: :any, arm64_big_sur: "d3813116a68c1dff782108f7248aab2e41ff4c315bb363c4ef5eb0f2c0b261ae"
    sha256 cellar: :any, big_sur:       "7c542650b39fc81df0bab663a5b91382a2d5e72df4efe3a6be32bce969f95975"
    sha256 cellar: :any, catalina:      "74e5dc08056f05ea84d6d656e3a6ab3a36c073901634a751af3b897e0d4ee701"
    sha256 cellar: :any, mojave:        "8dd1fe03d765cd2e9ce5929cc626ad27c0251be552e77ee12fec30122ace3675"
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
