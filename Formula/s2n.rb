class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "6978d731425d92f4891c7849549a29e0ec002fb76809b1c9da40dd265067fe3d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "00f6e95e5bafa03dce8d56ea32ca4ed7b7766293e48dba09152447dee3e149ce"
    sha256 cellar: :any, big_sur:       "d0b377e22e337e74aade64f7869ab5772602d748752b51672c8023d7cbe9f729"
    sha256 cellar: :any, catalina:      "79762e208b9a209e18f3b726f6c65afe2805e7dd287cee47eb26b46f1f716fc1"
    sha256 cellar: :any, mojave:        "6d54a09202b68182cdfd85ba2a2abf366bb5f84b1123f4043e469d8fb9c705f9"
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
