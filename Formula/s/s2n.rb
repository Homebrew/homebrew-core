class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "d913741fd8329b2ff4f9f153cb1b4a0a88e788f0217f28ded1f207db6fabd5eb"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f94b675abc502e4577e1ce0827ef37efce2101af5cf4b146e84dba6b2b302ab"
    sha256 cellar: :any,                 arm64_sequoia: "f54d5e88027f416ef89d1d79557eeee81b759b574fd463fc2e9a4d5455409997"
    sha256 cellar: :any,                 arm64_sonoma:  "9b9a67f370c38ec78d8d93d9f7e3da8a8f3a810d232c6cc525c4fd2d365a8287"
    sha256 cellar: :any,                 sonoma:        "240014f6bc35afb1f52f731cf22988cb6a236227010876553c591b75276350fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8912f1ddcc7cacc0e9731a81feed0250482a89270ab0516edcdd0ef4428775f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043cd3f0b8e57cf6962036580e0989b921a8868e761a1b3c06f33d276e7d44b5"
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
