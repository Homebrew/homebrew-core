class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.20/c-toxcore-0.2.20.tar.gz"
  sha256 "a9c89a8daea745d53e5d78e7aacb99c7b4792c4400a5a69c71238f45d6164f4c"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b51d03e981b5832b6a24558df53db302c4fe390f376101c9a149d2d5c7dd014"
    sha256 cellar: :any,                 arm64_sonoma:  "c79e553494531763dc31ebcf73b8e09422591649ade2bceaf256d2b104401627"
    sha256 cellar: :any,                 arm64_ventura: "e91b248155d9c00607aec320b8e0eedbd967ea18c347f32524c1ff3ef81d7d9c"
    sha256 cellar: :any,                 sonoma:        "919e2e5465f99745a84360b99fa84c939344e9a36b2c0722740d0a7e8b569840"
    sha256 cellar: :any,                 ventura:       "5ec3104da70c2c0d2f8763e3dc0642579d7ba9ae1a26eb1e6a47e72002827418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4654aa4c40c30cebec0fd99f5d410f1b3d3388b860adca5d4d28414546748d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a8822a0ab64a660e5f19c9b480c53e43358b89a8982f149bb0aeed40d00728"
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
