class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "907b2995d87dedd1fb30a78978b3c10e1604d7a7cfb2d57d7a1763d36d599686"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "022f7b3239dd3064a869fa415f4c1ecff65567c1288834ce86780476c335a6be"
    sha256 cellar: :any,                 arm64_ventura:  "250200b1a7dbcf1b8424031ba01ef41a1330df53095bb506b28e7ae43ca77fff"
    sha256 cellar: :any,                 arm64_monterey: "9923a47f54ac7dc29b2a52c4e8d5983e7fc4c619e04568252859fecff24060b5"
    sha256 cellar: :any,                 sonoma:         "1c4f1f2ce8b9e00dd890d8b4f71a5435a2aef4e49420158780f3bac2ca358e38"
    sha256 cellar: :any,                 ventura:        "ae63ae5b8fcb68cae23f0299b9808a9cbe49f92d379fe6cd104845e2d6963522"
    sha256 cellar: :any,                 monterey:       "5656bc4b6af3863bb0e0236a44e89b9134a9201611eed4d9bb194a4d2a1445cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fedc22c905b8849e863f4a0288f6b6b5203ef1eb8b9adb5241be7629a9a64210"
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
