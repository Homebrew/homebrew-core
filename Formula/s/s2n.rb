class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.51.tar.gz"
  sha256 "75c650493c42dddafd5dec6a42f2258ab52e501719ee5a337ec580cc958ea67a"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4303c5a05b241fb5a64b2ca570a70d4f1230f1aecb07e83b824eff112d9c6cd8"
    sha256 cellar: :any,                 arm64_monterey: "13aac1d4c2b52af8bb78dc2f84228685eaf54b51134dc38c69a8175bdc30ce6d"
    sha256 cellar: :any,                 arm64_big_sur:  "6733d262996b7cf7c35acff245fab3e42ffd582b87daf21f35cd26f22aedb120"
    sha256 cellar: :any,                 ventura:        "3b8d9c4f059a5020a34b1994efc560bb8aa24243835908e51d01a1c7fd2fdb45"
    sha256 cellar: :any,                 monterey:       "37027536c4ac6bb6f067bbce03ee72cbab0287435220f9acb463d7abad45edc3"
    sha256 cellar: :any,                 big_sur:        "218331802b5c224853e58113989deb2b5f2d8a564837697409b4d1689f509dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50c731bb26e98e831571316e776cbc85a4e1a1bc32c5065ef0c7840988269520"
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
