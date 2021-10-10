class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.1.1.tar.gz"
  sha256 "a17ef1e55b0a6c3d422b8b857bcfd26af7d2f8b33628a540854a6c17b8bed4d8"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2f66625a8f769663872a6a5b4e1f8415745e76a8f756f7f0c83e186ed956d982"
    sha256 cellar: :any, big_sur:       "86fd68cb22af4fa19d50775fb1a5e3df8895485ec7c272c84e2263e48c4c4110"
    sha256 cellar: :any, catalina:      "cbec5bdf97865378b170897a0e78cd82150c02abe17f7ddf1e8723412ef196b7"
    sha256 cellar: :any, mojave:        "5c1b77fd5e68617fc77ddde71f27588d623a4d4ab564de5717c974e319ae597f"
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
