class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.18/c-toxcore-0.2.18.tar.gz"
  sha256 "f2940537998863593e28bc6a6b5f56f09675f6cd8a28326b7bc31b4836c08942"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e970ecd155d6e65fdc327afb6f35048c53f8e78a896e268bc97e1c53365430ce"
    sha256 cellar: :any,                 arm64_ventura:  "83142dfc025243981093b3fc6bee44be73b9c3050b9d1f5a40ef3b7920fb5775"
    sha256 cellar: :any,                 arm64_monterey: "38c3e60372ce9ce1b4d4cbaf1dba6bcd83237fcae2de5fc333830dbfd3555cc7"
    sha256 cellar: :any,                 sonoma:         "fdf422e77dbba5bad498a305dbcae5b8a2917c525e4fbd8a52406a3519cdfc0b"
    sha256 cellar: :any,                 ventura:        "4386814e7f8fcd090c58e1e329d63383407fb8b5389917bf4413af9cf5b7ffb7"
    sha256 cellar: :any,                 monterey:       "3fa8b26eb52818e128cf62441cf6fbe025034472bc0953d5e70fa138f3995216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd442a9f9a372103190e5d6490cf84de89632e0fb656c8bbd38fe1d38042ccdb"
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
