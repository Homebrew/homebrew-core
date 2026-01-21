class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.21/c-toxcore-v0.2.21.tar.xz"
  sha256 "dde19a5eaa897f3b9ca6212e783a08753ad5c071deb14a73d84161853a067234"
  license "GPL-3.0-or-later"
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "050b0151151f4087dffb7dba9c69750d2f82aef2e5d61ff42643fd13dd818cc1"
    sha256 cellar: :any,                 arm64_sequoia: "137d837b7683dac068a82ce27e8e55446da055016325c9c73ac77b11938f1037"
    sha256 cellar: :any,                 arm64_sonoma:  "d16b1f9dc19c386cdcaacf38963055ccc4847030d5434b9000e7be647dcea28b"
    sha256 cellar: :any,                 sonoma:        "53486ce5425f28e3d33f36714a0853aee85b5b6205cad2a04f9e7896a2138e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4902d2da0346443d4378d7ba34e1ad4d7e91026a1aeeef0a87152803644ecbaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e988d944b8424cdeb67b056c5aa8ddef5728f975ef1e83c7f55db8f34f7c84"
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
