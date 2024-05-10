class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/0.14.3.tar.gz"
  sha256 "a22c708f351431d8736a0ac5c562414f2b7bb919a6292cbca1ff7ac0849cb0a7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "856f1bdf065edcacf362627362069a70f3377d4db8f2543e6cec45a2079de16b"
    sha256 cellar: :any,                 arm64_ventura:  "db7a0840092421df37617ea6cb1d4df598f392a8ac79ce2b4282d16d3827061a"
    sha256 cellar: :any,                 arm64_monterey: "8b2c807a78f030049caab10340bd50fb0ca50e024189521e9139408577cc3a59"
    sha256 cellar: :any,                 sonoma:         "9c5242871c11e30d642b00b18a02fc4214583ffb2450b8645a2a56cfcee46f5c"
    sha256 cellar: :any,                 ventura:        "73bd78a8a89a297410525491a25bc25430b742ce7f2c4e11acab0d4e9f90233b"
    sha256 cellar: :any,                 monterey:       "850416d7e71be7ca11c2a522de05b0fa27b94cf70658e668aeae70f6a1434282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e47c1f4f6cfb9ac56757254b7537ba9d2a6c94a791779928580a17e21cfb8388"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  on_linux do
    depends_on "libsecret"
  end

  fails_with gcc: "5"

  def install
    args = %w[-DBUILD_TRANSLATIONS=OFF -DBUILD_WITH_QT6=ON]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
