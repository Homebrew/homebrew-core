class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.4.tar.gz"
  sha256 "50946506413687e0c41922da05f470e4a0a5fff425639d72c1a5da7eb845020b"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "6bca7af90f4891a6b53d4e8f274087bc92a7d94fd4be47e899edad5f2e5cc506"
    sha256 cellar: :any, arm64_big_sur:  "f80351d742d76f1c8bf0e26b8b6457979f9816b514fa1e3d800f34d70f806183"
    sha256 cellar: :any, monterey:       "620a9f233211f6e507e415a1fd50c6a7672ef4add371a8c33e7a69d640434424"
    sha256 cellar: :any, big_sur:        "96d372877e3c736148cfd34f84639d08ce4b2af87824b17fe5d8ea7ae1b3a17b"
    sha256 cellar: :any, catalina:       "9d3ba9553f1829655a099770269edc42c1b877ef1706e5f5b45ef9c46831659d"
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
