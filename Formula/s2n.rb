class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.35.tar.gz"
  sha256 "9d32b26e6bfcc058d98248bf8fc231537e347395dd89cf62bb432b55c5da990d"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55e00d0bea988cafe5c2f8fc6ff9eac6bfc18059648845070621ec70a4037ccd"
    sha256 cellar: :any,                 arm64_monterey: "b74f385d49a879b0627488755988f9724359267357c519829562ba1d02a4c7d0"
    sha256 cellar: :any,                 arm64_big_sur:  "2c4acba9c9bcc7edc7cbf38119aa9cdfcfd82340629e3d337954b2de54ab1774"
    sha256 cellar: :any,                 ventura:        "fecd753a3643e58ecc002920b02fa506d104c0769247af6e38223fd816ea8315"
    sha256 cellar: :any,                 monterey:       "7d74a530f8626cab456c01aaf44c86c31be38f7ec7f6ea63636e8930e04585d2"
    sha256 cellar: :any,                 big_sur:        "38580d0aaf621ac159bb757f406bb4b51c463b5111c7d26a514b7c26df780322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43595cd247577cea4c27e21a2f6c36e243bd05c589554d30e27fa0d7fc591248"
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
