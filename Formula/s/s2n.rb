class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.17.tar.gz"
  sha256 "3ab786720ac23b35bcf6f4354659652e2ec8eb20b1a3989e7be93c3e7985ea5e"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f423ffe2ff71d13ebf9a435ce5e2201d1f83c110363c4b5ee8d3ed7788834fe"
    sha256 cellar: :any,                 arm64_sonoma:  "d324c5e441904e8b4b2e251e39aa4f16de1ce516bb6b90c924800988f4a78fd3"
    sha256 cellar: :any,                 arm64_ventura: "96c97520db477c44081308c42982165c3e33762f91f1f0e5b09da7611e608faf"
    sha256 cellar: :any,                 sonoma:        "d030af2340f1a2ab5e212ac7bb5f06f17bbbf26449aa64473ccb64b9348c43dd"
    sha256 cellar: :any,                 ventura:       "adedad6cddeabc2924ea856942d1fada5b6839eb97f12560c35a2471da04bc84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea32dcf493951b2d506a85057d134aaced55124fdf25af3864d7c392635be6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99f5b4231048f368e5e9c59ec599310579980daecd7c6333fb1ff5a7f7eae30"
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
