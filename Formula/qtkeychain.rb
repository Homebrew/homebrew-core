class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.12.0.tar.gz"
  sha256 "cc547d58c1402f6724d3ff89e4ca83389d9e2bdcfd9ae3d695fcdffa50a625a8"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "58b0ced7662d5f0659ff7d3002d5a8b09d1fb135d1ee51a94bffbdee24d0eb58"
    sha256 cellar: :any, big_sur:       "f97e360b724536ead639b64f637dc65ed60d90a7c2b3ca775c0af2c0e2c36873"
    sha256 cellar: :any, catalina:      "94f6a7cef2f131e5193b1eaf7bedb7ab6d89a00de318519624b75a355cd644a4"
    sha256 cellar: :any, mojave:        "325f6b601b8b004df1203f20d7355fa3f00c82602795ea701055b9eae577b0c5"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  def install
    system "cmake", ".", "-DBUILD_TRANSLATIONS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <qt5keychain/keychain.h>
      int main() {
        QKeychain::ReadPasswordJob job(QLatin1String(""));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lqt5keychain",
                    "-I#{Formula["qt@5"].opt_include}",
                    "-F#{Formula["qt@5"].opt_lib}", "-framework", "QtCore"
    system "./test"
  end
end
