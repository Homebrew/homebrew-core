class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.41.tar.gz"
  sha256 "46d68a57094f2671809d43263996d4ba36457a79e856cbcd721748a7b13c60ab"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3de39ee5ec00b179852fce1d43c349b8277ba64a5bead26c6ca8e6ae8552de92"
    sha256 cellar: :any,                 arm64_monterey: "629865b4d1ac0ec3487776a854cb880d20546bdf1f15bd1fb7265de36fa15d2a"
    sha256 cellar: :any,                 arm64_big_sur:  "56516f6fb80cb7ab5f210ca77216f1723282fa0d62d9ab3632d502e6764b4eea"
    sha256 cellar: :any,                 ventura:        "ef23b6dce086131fe90a05af3361e61da0e235cacfe4577b0210581d96fff0b8"
    sha256 cellar: :any,                 monterey:       "4118fa9699bb1ad6c857ec29e1c86c54da5a3fc3cb649c6d060aea2fd249b19d"
    sha256 cellar: :any,                 big_sur:        "658f310a8cfbcaa510dcaad77174431637719131ba109c3c6e08ee30193a8659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d96b13a69624ee24ee42eab0c1e11266e7dfc06932ea21df16ba02aecb5b36"
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
