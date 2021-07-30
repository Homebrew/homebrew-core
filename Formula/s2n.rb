class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "b8d8cf8f6547e8fdbecb0adb9402fdb8b375ee2d4519723b8b323bce25b42ad0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "63e2c66aaa36e1d7f28b9b58df8af5e637612e43321a91be13786cfc59c6ece3"
    sha256 cellar: :any, big_sur:       "df189a623206946aac185a919a053316b17c372c50660309063173f79a0175c1"
    sha256 cellar: :any, catalina:      "49fd0303f7194ffafadb6f733efef1884f1532e06b63e9af364c99f972cfec29"
    sha256 cellar: :any, mojave:        "38cc1fb44cb41dfe415c7d77b21f46a88c4e5afef95cbbf9c102a0d888517081"
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
