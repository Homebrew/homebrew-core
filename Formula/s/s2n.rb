class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "daf1cef574cdce15fe8be5d2b5632e90bd902ab6bdfc72687c7f574a28df437e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3b643c46cf3fba58b36b34eeadfce084d2747da7d34e973d03bcda97068e58fd"
    sha256 cellar: :any, arm64_tahoe:       "42a24451e9043beb7a3c661368ec349296cb135374548676c4028eeef15d6c46"
    sha256 cellar: :any, arm64_sequoia:     "e6b68e200211f4c84bd50612a3acf9366c8952a44efdcf3d5cfb4ae122fe1e3d"
    sha256 cellar: :any, arm64_linux:       "3de48c4a90cf6c6ca8ed0307747343702fcc94ded5c0ec03a7e9da3b30a6d007"
    sha256 cellar: :any, x86_64_linux:      "3d86e3640386db5843a1dcf4f3b3e58beea29e41420c9f5e1a1e91603eaf502c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

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
