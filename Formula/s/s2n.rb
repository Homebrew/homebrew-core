class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "31b7a6cc287799327fb414072d6d71168daa859939898726f84ca54fc6e45c3b"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "916f22ca6eb158a4c20246362af8c9611c03114aabfc0484f3ce79af0689b955"
    sha256 cellar: :any, arm64_sequoia: "b490746eb8de58e01c2c069d363f1659378478abeb5e25ff8bfd041cc25c4ca2"
    sha256 cellar: :any, arm64_sonoma:  "54f24a8ed3eb7a4b86244bc47611ccb9506336e1024ba0467c535c95b40ac6f9"
    sha256 cellar: :any, sonoma:        "c2618f03b9979b60d5c25a8d9384aa93f74835f12b22a0c8dbf299face4fbc87"
    sha256 cellar: :any, arm64_linux:   "ff35f4a08cf066672408db55d84231a880880745d2ea565f488b656504d7bf78"
    sha256 cellar: :any, x86_64_linux:  "795c6fef0c5b8863812e4f7f302ba0dc54f6f007d4ce915042992b4d9aa9ffe1"
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
