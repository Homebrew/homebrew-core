class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "a6f77d2e3343b554bfc2cce27e0407b3c758bb105533c8f0a56e233036b7541d"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d0ebedee604204fce4f295e0d07db4a33b1c1ea7d84af322317c9f422dc43444"
    sha256 cellar: :any, arm64_sequoia: "f1fcecbcaf6dd359fe3561405559a68f8400f36b0fe6838b74a5611f1e261b75"
    sha256 cellar: :any, arm64_sonoma:  "11d2d45520fa950eff0845be58986456866c24e292f25a63cd7d57e64bc4cd81"
    sha256 cellar: :any, sonoma:        "a75854248c836874da576018c1a7c6ab2b598225faf20be94dc9e3a58ffba4b1"
    sha256 cellar: :any, arm64_linux:   "bfada6c9e36e0127d4b381ed83339e46de2c667378cf9f4315b4949546bc648a"
    sha256 cellar: :any, x86_64_linux:  "c7f8f86c161b720b0ef9bc223aada7e9e2ec5599283f74a6b112f7c1e0aecbaf"
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
