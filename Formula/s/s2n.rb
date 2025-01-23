class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.11.tar.gz"
  sha256 "5690f030da35f86e3b5d61d1de150b5b52c84eef383799f7a706bdf21227417e"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8399e60cceb7a735668573557bad726cc5626951bcbc9e591d1837caa540c14"
    sha256 cellar: :any,                 arm64_sonoma:  "461339a25b5a6ca872df8d19e347268468876be226672b9c2aa7dc6b31acd867"
    sha256 cellar: :any,                 arm64_ventura: "153d21f5afc820ac4f7c840403b043e751c4d5fe9e83b5d1ddf0587ce6af2602"
    sha256 cellar: :any,                 sonoma:        "ea275eca88d8facbf2c88861054aa32b449a0bef87f520c030e74bb3292a7fd7"
    sha256 cellar: :any,                 ventura:       "db94ac9ea97b0d87ca9c3a1644ca3d93de07420f822885badcdcdf50e09a8a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d96073a2b5665442cbe2b7a6ef7ece24c2f4cdfd8ac70402d199971fbad9a8dd"
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
