class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "2d06016f69008e9edfb44f3916ffbe2f337731e28451f979bb2d4f752ff57f88"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dc8879ddd740b0b2284c400429589c2abeab6500b025f23c1593ee96d280ea25"
    sha256 cellar: :any, big_sur:       "4cb02b9f183823cf1c5f4909eb0dc2ffe5c58b504261b08d7ba6feabe83203a1"
    sha256 cellar: :any, catalina:      "da8e160fb7cb91f68d24864cbdde756b437de693c897662379ee0fccc2bc8901"
    sha256 cellar: :any, mojave:        "ba9efd4321f8c82069595b7949a92c63f67038ed95d18ac56d2910086d8335ba"
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
