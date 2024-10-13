class Toxcore < Formula
  desc "C library implementing the Tox peer to peer network protocol"
  homepage "https://tox.chat/"
  # This repo is a fork, but it is the source used by Debian, Fedora, and Arch,
  # and is the repo linked in the homepage.
  url "https://github.com/TokTok/c-toxcore/releases/download/v0.2.19/c-toxcore-0.2.19.tar.gz"
  sha256 "8b418f6470db085cf59a9915685613556556df2bf427148f1814b7b118628594"
  license "GPL-3.0-or-later"
  head "https://github.com/TokTok/c-toxcore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "70c7c932af4f833ca24d75838f2ca224a044d04e0f07d09efde7d4f4d795276c"
    sha256 cellar: :any,                 arm64_sonoma:   "30300b815fc78338acd0212162d90350e4df76fd1316e3949d5ee4a70f118f0f"
    sha256 cellar: :any,                 arm64_ventura:  "11b04f785c0d8b0a37aa08c3552135550fd14c49162ad00fa4062c7548a6a36a"
    sha256 cellar: :any,                 arm64_monterey: "dd944ecb1a42d3b983bb829599ce4a313ca2960f9e8d11e5e415d9ff09ff0b4c"
    sha256 cellar: :any,                 sonoma:         "afd20cc220e1f69c5ad5774d5e26705398ad07ff26a21920041300aced468a30"
    sha256 cellar: :any,                 ventura:        "4e55959905584119032dd94df6c00a50dce07917d38043767f34693b0a41fab4"
    sha256 cellar: :any,                 monterey:       "178acfc2f014001508a1cba3040a7ed8fa0d2f49c078fe031027e2110aa62b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2435483d57733f5aaf0d3222f8709013dc98bb778c89be1c6c0477954b8b686c"
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
