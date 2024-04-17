class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.12.tar.gz"
  sha256 "d0769f27eb9e6b8fc98d3e8e3eb87ed71e10b08fade87893b293878d84faaceb"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6a9f80085307d0ec3f524ab846c34a2dd709857ec08931b6eb047c5646d506f"
    sha256 cellar: :any,                 arm64_ventura:  "8109f51ffd09bfec74311bbde70ff6a908ec9e4f38741dc1545fb3e258007d94"
    sha256 cellar: :any,                 arm64_monterey: "4b6f327aba405525fbed980c9f3f636fc6a1b7e469973a75878d3b94822e8ba4"
    sha256 cellar: :any,                 sonoma:         "a1e3e63562cc2add1fe81007d5e546f6c20b3c9ef0e8f525d79160bb11da61e8"
    sha256 cellar: :any,                 ventura:        "dd60c07a8fd8ff9615f68892e88a70a1de0fe9c590d5148081e70a19a3b8711a"
    sha256 cellar: :any,                 monterey:       "7cf8feddb045de2d2d924844fe641cf704f2792955777243d97221bb142edeb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3a2800e5443d23c95aa7e7aeafe766d63d8cea28519fe9ca36494250bb6766"
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
