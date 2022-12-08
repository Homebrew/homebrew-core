class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.30.tar.gz"
  sha256 "b21d52fdfd52f7cf0c19084b8a43ef706bcfc89705fc5ec2baba2601cd6b53de"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "87802de81028a1400b6b8f3ad420d2512b897150d08baaa1225abc429cbd8a6b"
    sha256 cellar: :any,                 arm64_monterey: "1d688e2c562e5e1f185b468537b8b23568330a597ed72f14e1c8158d05e28f9b"
    sha256 cellar: :any,                 arm64_big_sur:  "b561924b20571b8b8d31cc8e63a62d5dba81a36bb8377b73d19ecf7684990235"
    sha256 cellar: :any,                 ventura:        "371e9864e69952dbdb5427d7a99cd7eefc1fdf978997fb60df7f4554552b6ee7"
    sha256 cellar: :any,                 monterey:       "4277c0c883fb9d8c789bf0aff9e26c5926148129e67999e8116b42b4dce47a12"
    sha256 cellar: :any,                 big_sur:        "c6f923839a1b9392ada5e668154bc32f8c0fc7f6d342f0a07071d5bfa4a5e529"
    sha256 cellar: :any,                 catalina:       "71fb69717e1fbefedf21b6c34d0e16dc4a64de36d444c9249d39b210618d789c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ba75fb6305b56392106bdfbfd13c0fa52b6abd3e5bf627b6cc8a8422388862"
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
