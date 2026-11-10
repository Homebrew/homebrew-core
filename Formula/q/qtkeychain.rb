class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/0.18.0.tar.gz"
  sha256 "837af59f2b950760a73eff81ccae817f7d3051183b447438dc610bb984a41691"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2a48353eef242e0905926c1932b30129528e1337e4e9230b06af17e843fbaeca"
    sha256 cellar: :any, arm64_tahoe:       "3809c5025f66848434dc45ae64b869403c03d8305ced079299d71bf3afce78b6"
    sha256 cellar: :any, arm64_sequoia:     "25ecdc4937b3b4231b7bfc3815ac22153ec8a3550e06413bcb2a5261ca179a40"
    sha256 cellar: :any, arm64_linux:       "8c225ab9fdc158b65d76ea694f3b81a79ecefb4c270f7a607c8852717a395487"
    sha256 cellar: :any, x86_64_linux:      "62641dd7cc0d7d4b38ed49c23a1e2e1048ce18ac64daed3bf815df10127c7f23"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qtbase"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  deny_network_access!

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
    flags = ["-I#{formula_opt_include("qtbase")}"]
    flags += if OS.mac?
      [
        "-F#{formula_opt_lib("qtbase")}",
        "-framework", "QtCore"
      ]
    else
      [
        "-fPIC",
        "-L#{formula_opt_lib("qtbase")}", "-lQt6Core",
        "-Wl,-rpath,#{formula_opt_lib("qtbase")}",
        "-Wl,-rpath,#{lib}"
      ]
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++17", "-I#{include}",
                    "-L#{lib}", "-lqt6keychain", *flags
    system "./test"
  end
end
