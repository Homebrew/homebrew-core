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
    sha256 cellar: :any,                 arm64_monterey: "c2c546e87431ea4917ab62d1e3cc9fb288aacf717cdde56201b2ab0b9ec53a25"
    sha256 cellar: :any,                 arm64_big_sur:  "dedd42434e7aa717549b6579939bd666aff3ec125899f346be4c9a2c28c40e1e"
    sha256 cellar: :any,                 monterey:       "250ca1e8dde831233a60d7de14094a919d88ec5d7364dcf663582b9727795a33"
    sha256 cellar: :any,                 big_sur:        "063a59c26b8a6f3c059ada0c5de5109696ce67704e2e09adf3c06bc28c6a9a79"
    sha256 cellar: :any,                 catalina:       "0dff428c19a7d139c1b493af68f755e90d36538ac5e3cffcad6eedffd2d0650c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78eeab62d36e41626e7b90d925b9b862fa1178057a764edec00e9010509a0712"
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
