class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.24/c-toxcore-v0.2.24.tar.xz"
  sha256 "abafde4c380598f01ef71592165e22c34a9dfa5ce88ad71dae0f949e0a994f99"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4894f0e4a7c2003a412eba139cdcf812c78f8cc4c3c0048b7819405a54809b10"
    sha256 cellar: :any, arm64_tahoe:       "999309f451e38e711dc23a3cf59c67b0e37038e3e7dd2fb41a63c95b3e4347f7"
    sha256 cellar: :any, arm64_sequoia:     "64c8baa3947871fb27e9fac813d5f2e9fda3e2258d160a4f371d7ca06fe9d628"
    sha256 cellar: :any, arm64_linux:       "c97187ef366f6d59ceb6bfc9b85c576a5c51117188b2feb798de6152938bc5d4"
    sha256 cellar: :any, x86_64_linux:      "97b271c640e7276a314aa79f55a8c3c0fef3bff95db38b36b09b9c5af5c2a82e"
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
