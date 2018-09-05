class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.9.1.tar.gz"
  sha256 "9c2762d9d0759a65cdb80106d547db83c6e9fdea66f1973c6e9014f867c6f28e"

  bottle do
    cellar :any
    sha256 "f9b7e82c191c67ab37a8307632254ef8c737c814472f64ee673148d5e2437397" => :mojave
    sha256 "762e3117de29b6935378bf54cfc0fd9a3d49ef35469a8621333bfb88d22c77a8" => :high_sierra
    sha256 "fd43ab15dd3da11cc4a7a5c068067af8a66e957317af8848892368e450ed6c17" => :sierra
    sha256 "2547d3aa216eeb767df920a63ed33f6a06ce355a59e0d3d70c2ce73a225af91f" => :el_capitan
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
