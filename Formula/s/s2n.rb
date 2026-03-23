class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/1.7.1.tar.gz"
  sha256 "850f001ea9b49d12a5ed5a9a4ada3c7aa042c0e9f2968604c457384adad31e83"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb2931d8813f61d7910e36de93a45109092d07bce38c966b59c1fe8dc12aa1d0"
    sha256 cellar: :any,                 arm64_sequoia: "c84a494d18e9c1e5f94288b2a342facb7a34d3e6fd40bb57a9a18993ffb84d15"
    sha256 cellar: :any,                 arm64_sonoma:  "6de8d1e14c1d2fc09257c78f27bbee6bc88df83f9b7d3f619aa36489b1ddac1d"
    sha256 cellar: :any,                 sonoma:        "469379a0a13f7c9ff00cff067174f75b3bf8d6d1e45bbef3541af2663c16a83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a088b753c78b31e5839e7fbf4fc567c27fb4d13c3891d60082656313a9b16a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f4224b84760fa8d741a60c6d54360913c4af544aaebcc229a9948cdbd6896b"
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
