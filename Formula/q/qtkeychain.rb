class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/0.14.2.tar.gz"
  sha256 "cf2e972b783ba66334a79a30f6b3a1ea794a1dc574d6c3bebae5ffd2f0399571"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe927224f500b509e6442db95d58963776b92b19103333414409103141f1c007"
    sha256 cellar: :any,                 arm64_ventura:  "b00db7d50723f11d8ac5c7c7893906bd1b688842915878203e469d95f3a84753"
    sha256 cellar: :any,                 arm64_monterey: "406606997f9a454ceab7fbffef501b5d5802d5e0ec48fe2ed6c17423c760bc38"
    sha256 cellar: :any,                 sonoma:         "60a1ff0e9da3639ed182bcbcd75ac3ab46a71d2a94458fae5028a5fa8836c178"
    sha256 cellar: :any,                 ventura:        "6f6280f1d1fb012615549fddbd7ecd9b2d408dc306795f1226b4635f2a00398f"
    sha256 cellar: :any,                 monterey:       "d443eadd9cd1f8ceec5c62d2ceefb7aecccc2d6b357d4b0befb34478c12c353b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1545ae7d1b8e33421d8f0bb35d992c11b84846988deec4a1b39526fcacc2819"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  on_linux do
    depends_on "libsecret"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DBUILD_TRANSLATIONS=OFF", "-DBUILD_WITH_QT6=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <qt6keychain/keychain.h>
      int main() {
        QKeychain::ReadPasswordJob job(QLatin1String(""));
        return 0;
      }
    EOS
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
