class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "3ca5361dabd2b041ba6d8c3fe73d1bc5a721dc5f62bbf71838010d1eddaa0cfd"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bda1015c8f5a962250b5afa5028d369a84ab36550db6e5ecc258f4a1121ab2e7"
    sha256 cellar: :any,                 arm64_sequoia: "5a3ce251c964e7995a66c1c841d68542153abd8a16ae3a2a46a13cb9707d08e7"
    sha256 cellar: :any,                 arm64_sonoma:  "d88902d8d819034f96d813a5d61f98a71969bcba0861fb938ca692808d2d9757"
    sha256 cellar: :any,                 sonoma:        "9ca264364cf92994378a3b26ee38e939523e5c54f9e4253cac2df7053a96f93a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d3db02f51cb8d2c4e9696bc00fc71aa6dd1d1cec60478ec980edf94b020aa85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a49c44117a72ce8b6e7aad8abb5f7ccf518b1b48033adfc7562f25dea5429a"
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
