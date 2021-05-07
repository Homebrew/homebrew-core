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
    sha256 cellar: :any, arm64_big_sur: "f9e492912aa8e024e45d557d9c442b16d75d1bb3c3c212b763ac2376be5f38da"
    sha256 cellar: :any, big_sur:       "c93f7a594b282245129acd15a1eed093c1f6072bf393da0be266d5b115bd77ce"
    sha256 cellar: :any, catalina:      "ebfa1265ec9fb37ceeb78d4fbc5174c268b2cf3e9b71929ee7e4da32a0a89fb8"
    sha256 cellar: :any, mojave:        "cda50594ffd340359e91b926b5be8fb6355cbc1d95364cb4de4f03fc97a26224"
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
