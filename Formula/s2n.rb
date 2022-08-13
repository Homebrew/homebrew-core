class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.19.tar.gz"
  sha256 "e110b46ad2a43aed2432459f7b7e95138ac04e7c8b93107103e0f5f4d49dcf65"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d866bbd8776f322b4b0baf6aa296bf3997a5d9bc319d8c5be37c1723be6304ab"
    sha256 cellar: :any,                 arm64_big_sur:  "8c5907db2a23e43489adb129a980fce04b3ce21766b610b7d1bd0479fe4e53af"
    sha256 cellar: :any,                 monterey:       "ab1b04643c0a259eca81eb8ba011556a2ed0bae71ab9bf9f0776f1bd8a6f52cb"
    sha256 cellar: :any,                 big_sur:        "0aeb0a0821651efa8418ab1878ac35d7b6213d362745ad568923679d5e1d3f66"
    sha256 cellar: :any,                 catalina:       "cabf35bc24ce6ebad849c77b8760aa379cd9cbc8f3340282f6cbd079329f8c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09956d107cd0a29966e9c85cc7dbd09dfa49f8ff8225c5dac5777350b70e534b"
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
