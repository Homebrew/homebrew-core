class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.13.2.tar.gz"
  sha256 "20beeb32de7c4eb0af9039b21e18370faf847ac8697ab3045906076afbc4caa5"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5d3145d8d3731343964b40bdb1c13c4e53e9be8322d32dadafe8c7d7875c4888"
    sha256 cellar: :any,                 arm64_monterey: "f40b525d2f5a5e6fc334593e7da4151872bc49d5dce33dd2a9964ece65691734"
    sha256 cellar: :any,                 arm64_big_sur:  "aa11a27547e6206efae29567019190a1ca94d50d3d241689a1f157fd70e2f962"
    sha256 cellar: :any,                 ventura:        "a10b143a072879a840b24ead5b3a04bd38cbe361b8f0290747c6f9407b611d30"
    sha256 cellar: :any,                 monterey:       "29f4b26ba055523d59cdf5e800a4402de27870cd2cbf938b8190a8ad3b7bb4f7"
    sha256 cellar: :any,                 big_sur:        "b27da2f84bb0b2357dc6c7274d63b00eb833aea7cc6dfe9126697993291193a8"
    sha256 cellar: :any,                 catalina:       "2ec32ec391cfdf76856c5b60e9b7d3d4e157e04c1925cd617d465ca8e916b349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d5e030c29fef9faef28773bd69d1334596a524679c65b8166ae5b1f2b96ce78"
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
