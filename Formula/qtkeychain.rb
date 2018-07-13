class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.9.0.tar.gz"
  sha256 "0935e5eb67fbed0b2db5e74ea8cbd667c6be6eed3767f212eac6ac318ab8a6fc"

  bottle do
    cellar :any
    sha256 "bd768dc482fd740ffaec73201f3e7a745f6a7710f484d93cfd64da5c0059972e" => :high_sierra
    sha256 "b0e452b48b65eb3856d1524e97ebd96180f9acfed9f43410b71017ee2af7649f" => :sierra
    sha256 "76083f856092b8da5a4d28c3f08e742bb9d809f1634e18448a2a7dadb56f50dc" => :el_capitan
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
