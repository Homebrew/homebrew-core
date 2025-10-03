class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.27.tar.gz"
  sha256 "95d6e5ada2d66108653e91de3ceea800987fde9eb190ef219034ab4fd06b114c"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d09f90ce2e8932fff4008fd62f361027abf14615c4ebcc1c5f42ceeab345ce2b"
    sha256 cellar: :any,                 arm64_sequoia: "03b6c0e2ce5b01706e7dc84984811c0eda9b71ecc32080e61d8c433ae2402c77"
    sha256 cellar: :any,                 arm64_sonoma:  "a0f875762b79fb9ee45a5dcd953bdab0c7e53fc5269124948a81d982e14fb280"
    sha256 cellar: :any,                 sonoma:        "58f7b073af6a45fb21af2a76045e1c5095c1b1dee627219d9869b4c10af2214d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6e392fe1dbe71d4c35d80e90ed716adcc7a0bc14f98acc7d9b6aff2854cb4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f81324513599ce87a19dc51f5ef2a44b5eb01beac7c1b096e46ca2fda1219791"
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
