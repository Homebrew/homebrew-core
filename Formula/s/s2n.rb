class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "6874dcd366b32650bb00d3e94c4435b698bc47cadcba35d67e0d58cdbea6fbf5"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ec93b58bae2f11bbf7115a1b4aa478fde1f7de50a23dd3ca0140e2d42587267"
    sha256 cellar: :any,                 arm64_sequoia: "98d8ba724f866648685a629835d0325577b5cd7c6b03e8533fdec776a1a0471c"
    sha256 cellar: :any,                 arm64_sonoma:  "8af528f4c77935d47ae7f8479ed290427730a0c928f5235ceb7096a478eb9bca"
    sha256 cellar: :any,                 sonoma:        "562ebe2bd011ff80afea218e2fe17fb0d2940050b37a3d7a62cff300cae33a67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad6c36a3b5b3046d8bbbe36c1c07b4968bd91e1c17a7fd6d4af69b046e829879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31b1981396df0e7c69e1a3f0b352ccd0182940daf4aacbb4f9ad39ebf79a64b7"
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
