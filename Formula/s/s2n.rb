class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "8a8b87b890de23c980aa31925241b52ee3fa49167f7c72bd6762e5d43d5fa892"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "98bb19919b50b98d0a4d43fd67afed30d3552187ccb25cdfa03a5108399ea791"
    sha256 cellar: :any, arm64_tahoe:       "f9d1307d3c328d8bdab146f09d2023a61f52335aa476749030a7d0d3ffeb9b99"
    sha256 cellar: :any, arm64_sequoia:     "a2c0402c68793387352f6280edd4a14e7e712a2971e8807cba45fd2d8543be9a"
    sha256 cellar: :any, arm64_linux:       "2863b37aaad46f43718a78b8b545469824802eab36ce6ae919ec2dd31779f4f7"
    sha256 cellar: :any, x86_64_linux:      "9d994a3f8f9f29c3c6524b5059334af225915340d08979b158adbb26784a9451"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

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
