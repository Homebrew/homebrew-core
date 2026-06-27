class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.23/c-toxcore-v0.2.23.tar.xz"
  sha256 "a6c3d559ac06eb6b9d48b3edc72f64a97df823c9f64f7dd97c3999ffdc05381b"
  license "GPL-3.0-or-later"
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be61c36f2d75c7a8ddfd426cca426d5d5415c7a2231912bd5d0f9b03bfffde7c"
    sha256 cellar: :any, arm64_sequoia: "18629a3bd9859806b30f36a1ecca6732ca8d39eea03bee3b9e5d8d61c70d2f34"
    sha256 cellar: :any, arm64_sonoma:  "17ad87fbbc239a376f2a3515650f2830b1ad2b574e8f23911d3dcd3dbbf79a8a"
    sha256 cellar: :any, sonoma:        "fc60d49a955a51bdba2e5c1d1966bc5d0f341bcfaa8703842afe9733ebd2abaf"
    sha256 cellar: :any, arm64_linux:   "2087f424bb492e8d937dbe211ddc52b4e91f30e223c7f08ae43645b71fcb3baf"
    sha256 cellar: :any, x86_64_linux:  "96ecbb342f92bb35f2f97d4f305a1ec446605f6c6f7f1f978f20e27fc74e58e8"
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
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/toxcore", "-L#{lib}", "-ltoxcore"
    system "./test"
  end
end
