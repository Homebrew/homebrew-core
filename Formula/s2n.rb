class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.22.tar.gz"
  sha256 "bac109210a365834d9c66659c851f16dfe2760caffad409bcc39c9cefc725817"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ee23453fe96d44d4b6d9d75b71a3844762b5f9ea3e0874ca7cf82a34c025b63"
    sha256 cellar: :any,                 arm64_big_sur:  "463d1b4ce99f8224521a0463d891b38fc85671199aa763006331c192cc5d05af"
    sha256 cellar: :any,                 monterey:       "2054d65d2289571a938c0c36957161e8858202f7cfdfff30954da3c7e3af1e52"
    sha256 cellar: :any,                 big_sur:        "f652e67bee55f2988c83f157981cfd02e544446aba2b3efd966757daba6c80f0"
    sha256 cellar: :any,                 catalina:       "515846a82d3f1568f8254850a6d88bcfada4854452c4c80dab4d4190cba3cb3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2be42bc45e319a6d2174639bce61a04c140891632747291ec90df1f0a08b71"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
