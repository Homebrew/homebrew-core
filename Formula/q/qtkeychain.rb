class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/0.15.0.tar.gz"
  sha256 "f4254dc8f0933b06d90672d683eab08ef770acd8336e44dfa030ce041dc2ca22"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "f216a5ed18ceca5e77ff086b75a0d02dec76f5cce3a6100c172b32e56088b690"
    sha256 cellar: :any,                 arm64_ventura: "a9eb0ce450facf448a458fc661474fdf6e11a8205791ffac65d7ada84717ace8"
    sha256 cellar: :any,                 sonoma:        "fa6264c1da4f266fb4ee57570009e9a5e44a15b0000cfd6bf99f3be6a721c6b3"
    sha256 cellar: :any,                 ventura:       "63a82f1f3487ffe900540bb42b4baccdfee18d0f689110ab3b2b1b435d010084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e41763b847c0e19b5fe15d7a61866bd06a0ea001765546462498e5941be9c99d"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    args = %w[-DBUILD_TRANSLATIONS=OFF -DBUILD_WITH_QT6=ON]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <qt6keychain/keychain.h>
      int main() {
        QKeychain::ReadPasswordJob job(QLatin1String(""));
        return 0;
      }
    CPP
    flags = ["-I#{Formula["qt"].opt_include}"]
    flags += if OS.mac?
      [
        "-F#{Formula["qt"].opt_lib}",
        "-framework", "QtCore"
      ]
    else
      [
        "-fPIC",
        "-L#{Formula["qt"].opt_lib}", "-lQt6Core",
        "-Wl,-rpath,#{Formula["qt"].opt_lib}",
        "-Wl,-rpath,#{lib}"
      ]
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++17", "-I#{include}",
                    "-L#{lib}", "-lqt6keychain", *flags
    system "./test"
  end
end
