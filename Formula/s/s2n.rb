class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.50.tar.gz"
  sha256 "19c9a7e9e0ce14aae3fc0c55995759f4eadd5b55f5353de69f82c62ccb3693f8"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "961d55710a9300e3999fdd9afdd874625c4e54ab47f586992c3cef8306f479ca"
    sha256 cellar: :any,                 arm64_monterey: "c55c6f3d16fbcf9493d7ec2673ad574c7b4eee580d7f667a72018e0481d317c8"
    sha256 cellar: :any,                 arm64_big_sur:  "e23d5f2ba71a5d716918be4774240f2d51a7e53acc24f4de54572fc7ca12e83f"
    sha256 cellar: :any,                 ventura:        "371bef9b9b6e5d3e5bd5a90a25392a54ccd2b50e23193efe0cecd5261331dd69"
    sha256 cellar: :any,                 monterey:       "739257592931ad79075bd52616f2a97a1f9aadde860312d360cc7265f914fe78"
    sha256 cellar: :any,                 big_sur:        "9b8bff703419d67176a0e89fcde438f4f79f5d2e21f7e3dc9d850868bce7d6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c14674a937dbe5fc091e879b78dba40464e0649dd019258f4cadadd38950a4ba"
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
