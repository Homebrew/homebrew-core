class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "9b7c52aa76b1773218ce9033875a35cb59f29fa7ce2d8de16132648bd75c2194"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02b7ab8883617006419f55d46d981b3325bd71aa0ae5f53642321ff98c0ebfae"
    sha256 cellar: :any,                 arm64_sequoia: "3a357898ffa381e8daee5d524f72017be87f11e5d2459edb1b66e4c67606d2dd"
    sha256 cellar: :any,                 arm64_sonoma:  "a49bfc5a42e165372c1b7787bacaf88098ea85da249cc4e464e3d51367a50e77"
    sha256 cellar: :any,                 sonoma:        "b646752e7d2e6e496521186a485c1ac2d673dd70f475dfe06668a590d4ff0c76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba362086f09ceca977b272a954c37ebf27ce60188d060fa406c0edb2875c6e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "069c78d5bc56e9ba00795702f2ba52749c395bc9d92e20be74144bf0903e2246"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
