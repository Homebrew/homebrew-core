class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://aws.github.io/s2n-tls/usage-guide/"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "8a8b87b890de23c980aa31925241b52ee3fa49167f7c72bd6762e5d43d5fa892"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a9692e41728dee66261036ac4f6554457180e9133bdae95d00cf5efebb9a817c"
    sha256 cellar: :any, arm64_tahoe:       "920f4a4af9da7fd54ead1a3d79532c21774551fea650367031075591c71ed83c"
    sha256 cellar: :any, arm64_sequoia:     "cbe081756ea280698ecef18bec710c89c6ea710b28475d2d252e88d1dfd92545"
    sha256 cellar: :any, arm64_linux:       "dde8c9471b6559edc3cd6ffa37c0e845989585aefa3c487415e58704918dd2f4"
    sha256 cellar: :any, x86_64_linux:      "8c68a5067229931896e5ef9101a45e3160b0d32920d2cf1a38dc269969062810"
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
