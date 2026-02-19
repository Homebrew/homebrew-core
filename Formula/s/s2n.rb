class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a6e8228e238239bb3c17b1eda3ed702bcbb2eaebc792eac4d754cc5619b0ea06"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca94f20f9515bbc532c75daa5139b002acdf6cef293580f1d41e46c5e8bc0463"
    sha256 cellar: :any,                 arm64_sequoia: "0788c487e889ddc4f0a4f630995935bc2bcd0a9db3f6edcaa8ad8fc5629b0063"
    sha256 cellar: :any,                 arm64_sonoma:  "387de3d2f399c6254fa6c0d92d44636f22e87db1912a808fd8ee09e2e00b1ace"
    sha256 cellar: :any,                 sonoma:        "de714207e93dc81581c5b39df944c2adafccb8e99fa817f7cf5c09bad9a062fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7538a6e5a8ec4141def33751194c7cf0620656c6183adc732eb8e11844278963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b41180743edfc682c30ec1afee892ca7f8c3d9920c6494b96c66c1d893f9558"
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
