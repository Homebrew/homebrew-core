class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.39.tar.gz"
  sha256 "7b32b3f61f609a5408f331d3e08c835981a5b8d1298b6ec8e8d6cf24a0a66a0c"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "606718b3866b9c861e74c9aa401cf3aba73d8a9d728788b531a9b61da250aa61"
    sha256 cellar: :any,                 arm64_monterey: "748d2f8ed7e6d22f87d12fb84863420d9882d649ca56d466741315e5f5bba041"
    sha256 cellar: :any,                 arm64_big_sur:  "f4f6d15fa1c64ed20b8e7b4f4a3e1edb6ad370455fdc22be3c00ab9624d275c0"
    sha256 cellar: :any,                 ventura:        "486c168e1b3a89ee717fcd17c8cb336e41b2b8f5406b49ca600ed03b3141cc97"
    sha256 cellar: :any,                 monterey:       "07edd7d6eefdf35d478019d5ab34eed8e98ec74649dd06e88aa0190d29722db3"
    sha256 cellar: :any,                 big_sur:        "617989eecf678af933ac0ccb76109259959b713e5c594ca6085dcb4435b2feff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcdd2c1e2619953ada24b26cfc26e0a472b338f0296b736e9685e9e88bd046e7"
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
