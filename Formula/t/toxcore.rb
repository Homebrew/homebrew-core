class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.25/c-toxcore-v0.2.25.tar.xz"
  sha256 "38022f6d334835799179e85a5fee1411164273820c653242e2ac8078963f7035"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    manifest_sha256 "48f9f8428bf7095d669f18befa72e46d76a3347da5418ce62f1c3754146e96d8"
    sha256 cellar: :any, arm64_golden_gate: "8a346f560c171312c774e794d070c495311a0135b86a66318c3d933dd8e068f6"
    sha256 cellar: :any, arm64_tahoe:       "d78c3ac7f0f8487e05051f9e55a036ba3bba55eb9ea99f62bf0f338e9358697c"
    sha256 cellar: :any, arm64_sequoia:     "abdf1d7fea6de829529a9d538faefd7e98513ef60168fb14501fe0cf2f56b77d"
    sha256 cellar: :any, arm64_linux:       "86d462fa30f74854290a419c7525647516efde3f7c0bc49541e957087273839f"
    sha256 cellar: :any, x86_64_linux:      "fd5275b8ba90595ae36c4599a387f81646fcfd12390ad54d821d90b43e9dabe4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libconfig"
  depends_on "libsodium"
  depends_on "libvpx"
  depends_on "opus"

  allow_network_access! :test

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
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/toxcore", "-L#{lib}", "-ltoxcore"
    system "./test"
  end
end
