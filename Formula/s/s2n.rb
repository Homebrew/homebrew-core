class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "ffb7f3dfaee7a05c041296e19ff0a079d01552ce2615ec14361a6458a0e22d18"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34f7b447c65e4283a5622748ef2969453820e3284f7f462e2b89b1fbb42a1159"
    sha256 cellar: :any,                 arm64_ventura:  "7f48d3cf0d8d7f84ca4edd4a6b15cc1a5a4abbeb98be1325ca4815ddd3d895ed"
    sha256 cellar: :any,                 arm64_monterey: "0e244817e3db8e3443dc24032b91d3c69aef713437fc02fdd918c9b1fb1545bb"
    sha256 cellar: :any,                 sonoma:         "21093ab4d66444780be5346278218a23bd9c2b2ca80e1f6d59d3f8adbf064104"
    sha256 cellar: :any,                 ventura:        "b1f1f5ee8a1c3e22a6ef7f294978476f84a6b3964cfab51a7c32b93d27925042"
    sha256 cellar: :any,                 monterey:       "08f22472bd217303a80ba3f968471f9974cff737760279660d865a6e1ad69cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d9f166cd6b1f27654208ed08c6b5b8b0ded75e724684c8042eecb13a58263eb"
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
