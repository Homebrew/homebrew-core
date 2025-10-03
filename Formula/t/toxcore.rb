class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.20/c-toxcore-0.2.20.tar.gz"
  sha256 "a9c89a8daea745d53e5d78e7aacb99c7b4792c4400a5a69c71238f45d6164f4c"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01071297d658e6e0851e482c7cb6d2d9ba8461e79fac25c41aaa0c585c7b9469"
    sha256 cellar: :any,                 arm64_sequoia: "3379c4a841b711aa33e822e3b99fedb344ef6cca8c23ac87ca636f16516bb7ff"
    sha256 cellar: :any,                 arm64_sonoma:  "61ed64fe45f6ce3191e5c53c04d2d49aa4c5cbfe739971e1f45cb42a7b400754"
    sha256 cellar: :any,                 arm64_ventura: "6bd944dabdce173a8d838e61b511bbdf0076a69ca244f06b8a4abe057b6df206"
    sha256 cellar: :any,                 sonoma:        "fbb6f976d3eb729b4a4cb934dbe11abb47ec1f90905c114a35636f3e9c1c3165"
    sha256 cellar: :any,                 ventura:       "2e8cb55ca687bde4925ae3d4b79bfcff988c7dce31c7a5b12e337392609fe1bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff21beb0e5b1a7f90489cd6b5d0130713a6b5c59cdfcc3565b706f3299342112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1118526ac90564b275c1b5d2373fb942448fe6d2edc513c728eea469d3f8f5d9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libconfig"
  depends_on "libsodium"
  depends_on "libvpx"
  depends_on "opus"

  def install
    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tox/tox.h>
      int main() {
        TOX_ERR_NEW err_new;
        Tox *tox = tox_new(NULL, &err_new);
        if (err_new != TOX_ERR_NEW_OK) {
          return 1;
        }
        return 0;
      }
    C
    system ENV.cc, "-I#{include}/toxcore", testpath/"test.c",
                   "-L#{lib}", "-ltoxcore", "-o", "test"
    system "./test"
  end
end
