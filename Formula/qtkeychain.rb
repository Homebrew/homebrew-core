class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.13.1.tar.gz"
  sha256 "dc84aea039b81f2613c7845d2ac88bad1cf3a06646ec8af0f7276372bb010c11"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ff419e0cddb47f36d42355203426dec0ac362f9acd22de6b34ddbf4aa9d7c17b"
    sha256 cellar: :any, arm64_big_sur:  "511adb80d2f17ff444968a1d423ff5480722b0e57c1c5f9c7ed97baa9a5eeec5"
    sha256 cellar: :any, big_sur:        "6a67508572e1cb4b3fa76149a14a2b9d12759b1e7f2de9d0f3e505dfd7e3e19a"
    sha256 cellar: :any, catalina:       "8ecc8110a025909e6a4523d68e8409e67b0453c812632a01e43bd92f1530da18"
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
