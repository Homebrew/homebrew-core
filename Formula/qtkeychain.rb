class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.10.0.tar.gz"
  sha256 "5f916cd97843de550467db32d2e10f218b904af5b21cfdfcc7c6425d7dfc3ec2"

  bottle do
    cellar :any
    sha256 "fc74803523e8bcaff20f75ad93ecdc73eedb133e98e944cc569b686bb7b14706" => :catalina
    sha256 "ecb65ad1c7ad4d6d13e1e954009866967c76c2473c0e7409735dc77cad09f16e" => :mojave
    sha256 "bc583e9bcea87e8c2c13dedbe3cde99cf34e9c59af2f142bcfabc0569bf8c12e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "qt"

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
                    "-I#{Formula["qt"].opt_include}",
                    "-F#{Formula["qt"].opt_lib}", "-framework", "QtCore"
    system "./test"
  end
end
