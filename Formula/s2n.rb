class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.44.tar.gz"
  sha256 "16b25209bfe08c9d14c74277f2e98bba90bc9c37cae3885ad4122c545c3110c8"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ccb8fc8c32c08fb0701aebbb6668b5346c4ed22931fa1bd9ef41179585dc2ed2"
    sha256 cellar: :any,                 arm64_monterey: "8454bc20787d506d2962ea7cd93d3deb073fb5f2e8109715aab3ca931479df96"
    sha256 cellar: :any,                 arm64_big_sur:  "1ed0fa802ffa727acbb2e0254573373489c3d994f6c6ebb30c77ba201ae33e60"
    sha256 cellar: :any,                 ventura:        "2c88e582d862d3bf6f62bf529809399fa4ff966b463f63add168f531c8282a02"
    sha256 cellar: :any,                 monterey:       "883c5a8a3fc8e3b22ea7a061e0e528d2f715b2204161a702ad0f67eddc63a610"
    sha256 cellar: :any,                 big_sur:        "7a220baf538fe532786b23471b464767cbe4379a8da4345aaba543bfba257ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bdf9cca61416dd52e1212779df92722310453d402928409c53a16b7fb743f06"
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
