class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.15.tar.gz"
  sha256 "e3fc3405bb56334cbec90c35cbdf0e8a0f53199749a3f4b8fddb8d8a41e6db8b"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6637ca7fec4083f93a9f0a318edb51a7d827a73aa7f261f7fa7a4326988ef448"
    sha256 cellar: :any,                 arm64_big_sur:  "79671b2f241353af42b244db3c0d414aedeafea48e6e7894db278a5ff4ecb513"
    sha256 cellar: :any,                 monterey:       "42521d3e53896981b39442b69e94d68b9d00274dc3657f6f0de84bcaf65c46f4"
    sha256 cellar: :any,                 big_sur:        "570fb503c7432398a68a1a87b5636619a98718db13d9ea854f5ea4ea8fddbc57"
    sha256 cellar: :any,                 catalina:       "08e323981082a2e069d410eb152c9c13f78bda0056fd544398cce62af4359233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9fa33b75bf19769ddb6e49c335725edc7fc7e295b978bea810dbbc0e3f7c9a6"
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
