class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.26.tar.gz"
  sha256 "62e1f40bc4fa96ce838c9833a2068844ae7f7b288cf96766d6b9939f06c967d8"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "512c9057117b070daeb36bc3d99880d60f22cd79058e6e3bf4f3b47815c98455"
    sha256 cellar: :any,                 arm64_big_sur:  "bd4f384d14b2cb92d4cc245cb875e9e3d7c25bac181bbdf8b70574cb7b68764d"
    sha256 cellar: :any,                 monterey:       "9cbb6b7e8c4b4d217db52c30a3e8d18126bd041721a67ff6cfadfa3cbab069b8"
    sha256 cellar: :any,                 big_sur:        "18630a89b0c285b5b92b8d5e696de8bcb91910d281d96eb25cce356a07c05b91"
    sha256 cellar: :any,                 catalina:       "020a0745f49b33beaf05ba91e51d820f4efa3817ffddc48ea856a609e163fe59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d4a4c72bc91b54c511423817435169c05318c98fc2d40d2e3236c7a57c55ef"
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
