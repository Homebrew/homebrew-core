class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.18/c-toxcore-0.2.18.tar.gz"
  sha256 "f2940537998863593e28bc6a6b5f56f09675f6cd8a28326b7bc31b4836c08942"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a3ef8820b22039a287ffb04ed6aecbdf075b2b69c5d3f4b8923fb858d1f161b"
    sha256 cellar: :any,                 arm64_monterey: "d51bbd50a024f4d6d36b4b5edc93c0db0282e77bfabc5780d260ca08892a9613"
    sha256 cellar: :any,                 arm64_big_sur:  "05fa35021af94207613fa41a15a5dd01d72c24fb5a0cb94d4ee22cc2adc817cb"
    sha256 cellar: :any,                 ventura:        "42077d19b06dd8fe3b6e41c367f923d89b1153e4eb4a25f2e2d493a155e46d17"
    sha256 cellar: :any,                 monterey:       "abed8294721cb6be0f8c21e4acf531ecd24bfe7b39139f37d0bdc223e37bb8e2"
    sha256 cellar: :any,                 big_sur:        "e520954d4768276db131418b629d1df677baf0eea536897eef2614067b3731be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208c0afe6069c8401b10786609b3ebd5b58250b8611933731aeb471495c1a335"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
    (testpath/"test.c").write <<~EOS
      #include <tox/tox.h>
      int main() {
        TOX_ERR_NEW err_new;
        Tox *tox = tox_new(NULL, &err_new);
        if (err_new != TOX_ERR_NEW_OK) {
           return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/toxcore", testpath/"test.c",
                   "-L#{lib}", "-ltoxcore", "-o", "test"
    system "./test"
  end
end
