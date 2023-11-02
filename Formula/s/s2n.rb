class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.3.56.tar.gz"
  sha256 "5d7bab81357a564453bc453469b4ae02936f1f35225ad297b8d846d2ecdda521"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2985dc2ab02b3a6d20786a31b034a9064f5afc3215bcc0a3683ea0a3b8b34c1"
    sha256 cellar: :any,                 arm64_ventura:  "c3de7aa6b45c6e9a2bc4ff44017bbb3503e956942fd32bf4a1cce28ecf8c85c6"
    sha256 cellar: :any,                 arm64_monterey: "a8b96dd77edef4a8a2d27b0a79df585d798fc6529a627e2594af58ae7cdbd505"
    sha256 cellar: :any,                 sonoma:         "4f7800da2834788d79fc956248dd8e450162029b8fbfbfaf0cb9b7173a139184"
    sha256 cellar: :any,                 ventura:        "161069b912cf6b5acc8ea6fb1626e865da21a3d7de1027a50681eadd7095ff99"
    sha256 cellar: :any,                 monterey:       "a6696d1b96f70d0051ffcbff17a765b7bb2afef7830b64824e95ca6c69d12da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc452a88aad0e229b78659423303ad1e8b6524065db75b709946bf7524f9cee"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
