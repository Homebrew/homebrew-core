class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/0.15.0.tar.gz"
  sha256 "f4254dc8f0933b06d90672d683eab08ef770acd8336e44dfa030ce041dc2ca22"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4bac16d3d1b6ea7c7ef54da66872ca0b6eb106be5d8fe9a3b293bec8f28e5612"
    sha256 cellar: :any,                 arm64_sequoia: "fe4522c0672e68076e5a6caabade89eb43f0842af5d10a2f6b9bffbf1c60918e"
    sha256 cellar: :any,                 arm64_sonoma:  "8e25450053fa00c0c96a1a458b8a71eb6f01eb2dfff70ae9621106f863b2bbf5"
    sha256 cellar: :any,                 sonoma:        "94c0e9f2d3d3723769cc8084e3bef5e15f0990844782743a2f6fc501a7fc640c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1802b46a69c8458733001a41570a683c32bbccb682dc8dd9440af5ba774fc84f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8606b46a5628d4ac64761e1bd0e5ae118c18267cbae6b9cbd8f2c0e95a26a8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qtbase"

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
    flags = ["-I#{Formula["qtbase"].opt_include}"]
    flags += if OS.mac?
      [
        "-F#{Formula["qtbase"].opt_lib}",
        "-framework", "QtCore"
      ]
    else
      [
        "-fPIC",
        "-L#{Formula["qtbase"].opt_lib}", "-lQt6Core",
        "-Wl,-rpath,#{Formula["qtbase"].opt_lib}",
        "-Wl,-rpath,#{lib}"
      ]
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++17", "-I#{include}",
                    "-L#{lib}", "-lqt6keychain", *flags
    system "./test"
  end
end
