class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.26.tar.gz"
  sha256 "22c3e73d5deaff691caf66e0303e23d0f531dc64eb70cb8028c7dcda467f9b31"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0716b08cedc247ec8ac9c289a70bb047011efcfb40879fc4d8686a65453655ee"
    sha256 cellar: :any,                 arm64_sequoia: "b697a428a2c28e84c5ef10dffddbe8f129050dff6e315607fcaf4d052534b080"
    sha256 cellar: :any,                 arm64_sonoma:  "3e9420c33d8bf3dd57ee5cfec8fb8bc36b8a4760f98268f41bdd5a4582a3c964"
    sha256 cellar: :any,                 sonoma:        "331a2489dc557c78631fc0bb13ace127e2f07cd32846b8e158a1f293c46bcee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad5caf126c530f867ee72ecd057e0e7171d5277e409bc6dc7081d5a2b6e1a2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebcdd851239b7619f32203a8bfebcc94edff06358197c4d82b3ee355ba8822c3"
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
