class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.9.tar.gz"
  sha256 "09f03600d45cac99b8495f9c7aa5f70a83b5c02867a3018a1ba9975d53184658"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a5a956486457b1b2a2e21547aece964ef86b56b8f6e7636bc75405e34164f9e2"
    sha256 cellar: :any,                 arm64_big_sur:  "15b4c10eeec8033b0e626a503a3b08fde0b098421b307327f8d5a143e4c5732a"
    sha256 cellar: :any,                 monterey:       "364c5e2bb2394262b28c5f306075ec7803fb42e3f7521e51c63eb8d3657b40bc"
    sha256 cellar: :any,                 big_sur:        "74b51ee3f7096890762e6e3b2847888fcc87bdbfd9d8070e3693f0a8c7538e5a"
    sha256 cellar: :any,                 catalina:       "885b08c3d9ed6e4216733579726e3e7163000b9bbf38c835071b2ca283638aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "384ca8d8785e4f61a683b0ddd30c0a3ccd565499ce2f55b1e4015eeaaed3de81"
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
