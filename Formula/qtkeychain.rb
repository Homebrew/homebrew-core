class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.13.2.tar.gz"
  sha256 "20beeb32de7c4eb0af9039b21e18370faf847ac8697ab3045906076afbc4caa5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9f6273da5cdc3a82058af46017b0ac4574e8a20f56849bc16794fe9b3ef945cf"
    sha256 cellar: :any,                 arm64_big_sur:  "615cd8a1cfbd5daa8ae059e28917dc55ba419167883c7d8463fb94d5cea2cb7d"
    sha256 cellar: :any,                 monterey:       "a78b8d50819e475246deea381583be33b13987dd4cacb41ca46b54b3a6cff350"
    sha256 cellar: :any,                 big_sur:        "356725f06e060f9d4d35428475911611c0f5da9373ab5be3c798233d229a6fd1"
    sha256 cellar: :any,                 catalina:       "e7c7b7c43afce3092702f14055dfd48afbdf92aec23adc443fbf31994a7df053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb921e5618fc59a027a8189843e0397603b4237965a0c15fc4369b91caa8a41e"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
    depends_on "libsecret"
  end

  fails_with gcc: "5"

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
    flags = ["-I#{Formula["qt@5"].opt_include}"]
    flags += if OS.mac?
      [
        "-F#{Formula["qt@5"].opt_lib}",
        "-framework", "QtCore"
      ]
    else
      [
        "-fPIC",
        "-L#{Formula["qt@5"].opt_lib}", "-lQt5Core",
        "-Wl,-rpath,#{Formula["qt@5"].opt_lib}"
      ]
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lqt5keychain", *flags
    system "./test"
  end
end
