class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.37.tar.gz"
  sha256 "61abf85c9895c980348aafe0ffe6ee0e1a263c809853c0161395902f91e4a44f"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89b418d93ed830176c9e3943489ef6980c87576ab6579c3a39db1d44387e89d2"
    sha256 cellar: :any,                 arm64_monterey: "62bae419bbde8c0da848dfe55d907e9c1524fdc8a0f14249f756c94085d79606"
    sha256 cellar: :any,                 arm64_big_sur:  "738a2125a947ed49e56a614d0d6ecea2a515b3f7406edc0a8245417d293f9feb"
    sha256 cellar: :any,                 ventura:        "577a02f3704d31ee57bd2d0431d410b118120260fdf1cdbebf089a84d041c54a"
    sha256 cellar: :any,                 monterey:       "e4180b53c5c78c174aa4641d05f006e9ac1430e7d62ad9824baa96e031007a0b"
    sha256 cellar: :any,                 big_sur:        "9134a7c55bde4104e9ad86e31faf16352fc1ae1b85dd42b2aa11a71e8ea78adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd0c542bb7bed39a83e04c2dc414848141e4c2b0935fd9a53196ad31107451b"
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
