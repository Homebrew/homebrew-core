class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.49.tar.gz"
  sha256 "2bc7b170a750a435ad02ab8e696c3ad6e9bb7a585c02899472793f87670184dd"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f4711cee6e93d194997cd0702e2818fca110967502360123de93ce099e0084aa"
    sha256 cellar: :any,                 arm64_monterey: "75b9c0eca053595415e7a7e471cde09b612dc429cf80ec495493453fc9cc56a1"
    sha256 cellar: :any,                 arm64_big_sur:  "85cc233c19d566737b387a1b5497f23f258c76f7d67194581c904d792a987aa0"
    sha256 cellar: :any,                 ventura:        "af968cafe1798bc18e18fb2478c9c51858ec52f3e26e65beb9cba56a43942743"
    sha256 cellar: :any,                 monterey:       "3f611fae21a24e6a24a042227538ca8667c231a31c9d807cc79895a2bcd3084e"
    sha256 cellar: :any,                 big_sur:        "045460fa25177aea13431ba964c5345170edd64142401ecb319473ba35f02aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc92826bb6d9e33cc20765e652c4efc36faf3bbb8a8356ce7a410c067f493acb"
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
