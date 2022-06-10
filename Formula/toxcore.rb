class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.18/c-toxcore-0.2.18.tar.gz"
  sha256 "f2940537998863593e28bc6a6b5f56f09675f6cd8a28326b7bc31b4836c08942"
  license "GPL-3.0-or-later"
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6277c36679255dce2b2e7871f12ce639459ce3d5cdbe407bb1d72d2b2eb6e4f6"
    sha256 cellar: :any,                 arm64_big_sur:  "855c9fa777d64f3e02a9f63aa9e64775c4f1d1833efeaf58af70c3d2d6528962"
    sha256 cellar: :any,                 monterey:       "488b94a6c29523fc399fee226289fbbc5efddfa6ad5c59fa934ce60dddf686e7"
    sha256 cellar: :any,                 big_sur:        "ae90463b2d543b391adb410fcd6b5e5a80e33eed3f714a256fecc914d450468d"
    sha256 cellar: :any,                 catalina:       "a865c7eb2ba80e585364f1a6bbb40008a7a58a63a8e8ec2a6811ae53636e09c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ac05dd681117beb656643d29e19ff73b9c6c19e8a45fb29977ea2bcfef858c"
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
