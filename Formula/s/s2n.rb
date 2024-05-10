class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.13.tar.gz"
  sha256 "8b0b36697963d6752e5a1b49e28e393605990d348edf1aef6f39c33164d45edb"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79179731c3a00bed649285d9caafccbe30fb71508ef7a39f8a63c6e93e3ef8ac"
    sha256 cellar: :any,                 arm64_ventura:  "c7ff6fb6555bf3e7ebd2d6512a3f9f6a1939d0817a7d9c67bba8e421e311bdd5"
    sha256 cellar: :any,                 arm64_monterey: "161297a4b0b1df28d08d5acc8afe93989e4dbbf487d16e5b6d201891731a5da5"
    sha256 cellar: :any,                 sonoma:         "1ea36f9a6ce5e537351a0c37a3fd2357aea4abad2cdc99b013271330428796a8"
    sha256 cellar: :any,                 ventura:        "b9297f90feab5db7e8a8d3dedeea19b455f8e90362a3340dc51a199586e62359"
    sha256 cellar: :any,                 monterey:       "44de1f45d20192fba1abc35ba46b37778b276baa5d1ab57e8ed0f38942ede2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3324b8c399b9606dbf4dcfee486109c7a31e0d9291c5035fd2c3ab2d9f8a895"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  conflicts_with "aws-sdk-cpp", because: "both install s2n/unstable/crl.h"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
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
