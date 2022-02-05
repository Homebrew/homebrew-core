class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.6.tar.gz"
  sha256 "014eb4190b4cc9301b99bbbc11cc874c38fbf1c73ba77bca922458a052a58ed3"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "48043394517a02aadc63c9e32405853611a14af764795fd2ca1c3dbea5c91d86"
    sha256 cellar: :any, arm64_big_sur:  "8015da5fb967d35344547b9ca590abc781b38ad4008d653ed7909d5882a5a354"
    sha256 cellar: :any, monterey:       "f425d689026df981a0acdde3e9e5ca0fb81d9bd244e4dce630205e30f99bfb74"
    sha256 cellar: :any, big_sur:        "03fada70a5721d919894acc183ffb579cc7e7404143b1edea95dac9713f718df"
    sha256 cellar: :any, catalina:       "0480e8dd5e5fa66b7ea30f2b1db8d0b845bcaee620c730c3c83bad07439705c4"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
