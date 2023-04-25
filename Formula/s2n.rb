class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.42.tar.gz"
  sha256 "b1287f71753cd3812fd3d6cfa91c458840f98c891fae6d5585a0ee09477cb8ff"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "746183550d00edc8ffadae61904e58e2fc06a7f37b4908b5195e17fa8c0a9abd"
    sha256 cellar: :any,                 arm64_monterey: "15a7d688b34be100e48ab9e661026db9b82d5656ec466452352c553122acd626"
    sha256 cellar: :any,                 arm64_big_sur:  "9a7b60968c633d89276ec1a6a72932f5da0bda6ec907154253742eec1e33c0ef"
    sha256 cellar: :any,                 ventura:        "3dee359f94360a41181c34d50bce2363f6a589e8870004295c493e214bfc097f"
    sha256 cellar: :any,                 monterey:       "e66e7d3cd91695576ae0171b415b6b5c590343e7fe9f9a2fb54c58ea2229a383"
    sha256 cellar: :any,                 big_sur:        "e801771fe88a627a1b8845d00d99ba91eb6c8b99630b37026c124193271bf249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42836fef0a85dbc58253f4ab7b082116411d7048ef4bf7cb12a4e129ae0fa6d9"
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
