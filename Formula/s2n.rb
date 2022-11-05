class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.27.tar.gz"
  sha256 "58dde9979867a3209a19098ffcd748a144b2462ec81edca5baf864313ff4f589"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01a5b9a4a9e8f900891fec27de29acfb2a8e6df553be9477e33700b54bc5099e"
    sha256 cellar: :any,                 arm64_monterey: "8f4422418940c5111ffebed8af206f53a27ca36f1af81c331e169ee223a0454e"
    sha256 cellar: :any,                 arm64_big_sur:  "6e67c463d23da7c9d770b5fc80224ce57b5f39285d2aa0982bfc53f65b9816bf"
    sha256 cellar: :any,                 monterey:       "be1a1f7cb1fd14e8a25cf96508c0de41adf8957ca5293e88b81a38529cadf474"
    sha256 cellar: :any,                 big_sur:        "e1d02eb5233539275a241e9f831c5ff7e2c577ac554711653c60a8f96e54c511"
    sha256 cellar: :any,                 catalina:       "43defb68aaec65ccd1cd0c3454e9ddf5d70e9676ab00951a5ae7a4847fb2251b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c51f48832c140a166602d089c79ece3e3f7573ac4851a87ab8e0ec70def79a4f"
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
