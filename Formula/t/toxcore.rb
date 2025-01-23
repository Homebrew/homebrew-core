class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.20/c-toxcore-0.2.20.tar.gz"
  sha256 "a9c89a8daea745d53e5d78e7aacb99c7b4792c4400a5a69c71238f45d6164f4c"
  license "GPL-3.0-or-later"
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e2a14e9598e599c0f311145c328d9d274b17c74f03fb4f795db32ac55c826a4"
    sha256 cellar: :any,                 arm64_sonoma:  "a969319efbe57bc7657603eea87f56a0668d6ea1b042dad62f3f613f98d1b770"
    sha256 cellar: :any,                 arm64_ventura: "1d9a839019b2ca24cea932c60127b4418cdf1dc7d0a94755799fff1d0c62db9f"
    sha256 cellar: :any,                 sonoma:        "6466f7b075609f7980cba36ecc5bc35a96ae5558f88ae9f698613600809e591c"
    sha256 cellar: :any,                 ventura:       "ae3dfbf4c1f8ffaa59cfe4391535180386be2fa811b91234870c7abfabd0272d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2443ece50296533188f88dc789916e6266a02253915cc56227d627ce41adc42"
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
