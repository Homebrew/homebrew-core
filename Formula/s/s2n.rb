class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.16.tar.gz"
  sha256 "ab3e19f899e9b76cf7141f3b287e865db628f9e024360d7086c7f9c901909214"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "357faf3c6d9291675a870f56227f7f40bb7f6b99f20a62b4b93182a2498d01ed"
    sha256 cellar: :any,                 arm64_sonoma:  "02f7bc6eb921f9af9f5ec48253508e05e698dbe216beaccf6768a28324baef54"
    sha256 cellar: :any,                 arm64_ventura: "ad839eb9f0b7c067570dc4511ec266dc9823273d75a01ff4048f4cfd1d0704d2"
    sha256 cellar: :any,                 sonoma:        "7d5ed3b987ad4683df1c05ab7ca20417676b3ddac8c4e9518e35f7491211763b"
    sha256 cellar: :any,                 ventura:       "41fe921c62a7bacd0eb6cc9fa8258b7731e6ce636caaf06774caffa6059d3261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b12eaf706a3884e2abc2e6d6ae95538c60720e50e1ed2418404395529f92115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d43820330602684ae181763a88db84d50da06d520f5b37e6fec21e5294fd5c44"
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
