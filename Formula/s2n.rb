class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.13.tar.gz"
  sha256 "baddbbfa57eb5e58f3496d62e349fbe76ecb2bb4adc4968d7b6450785ff74711"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f3313570492f26aa792cbecd3d612fd4b4ff20f6edbeeb32a63017480de436f7"
    sha256 cellar: :any,                 arm64_big_sur:  "9b5870e505650c8658d831d2589f9e84b61dcf0e5baf63c23ad934d2fa696a85"
    sha256 cellar: :any,                 monterey:       "c71684a7dd2d8440dc899482be61ed448fd2a52cfe8a25078e9d9155be6e6220"
    sha256 cellar: :any,                 big_sur:        "ef7a39711a8173c95f158a34718d4da19a78f2852fee87dbc74cd9dc3b5a4d75"
    sha256 cellar: :any,                 catalina:       "a13298612d7abc87332b2f8aec89171683f5234266718665cb2ce90985028cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7492abefda42cfd696f8df5357ba314a0ec8878a17ab840a1436bb8075e67d47"
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
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
