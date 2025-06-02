class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.5.20.tar.gz"
  sha256 "1d05303ba8383f62273c51b50147391c23375e918d525b7c827f7aeb69e6b102"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a77712edde2bf481372c414fe5854a85a359d92e52e07a9b271aa202f3d9aff"
    sha256 cellar: :any,                 arm64_sonoma:  "9a59250e0540b27f0e7f2fdf4125caa42e0314e7103fa22d432bc6900bcc2b92"
    sha256 cellar: :any,                 arm64_ventura: "60896ddeceb042d775837b6d3e0c8d783f8cbdab3e57aebf841f2e1d90e2dce8"
    sha256 cellar: :any,                 sonoma:        "b866b9a299533f81e78ad14074511662fc074252e093f41e997d019ed7beba19"
    sha256 cellar: :any,                 ventura:       "dedc527d1f9b962e3f82c8f2b197123787794d564d2a5624ed64dc36157d967a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d4c9e4e306160ecc35e596844fe1a21c229d059d0e233af0f599582c6a77d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbc07e69df982ebe5970f6b91f7af3037cbfff32897a6038aa5c3fdd38cf6c9b"
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
