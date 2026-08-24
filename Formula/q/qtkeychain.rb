class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/0.17.0.tar.gz"
  sha256 "3b85c3929034b0a99da777130c34d99f006fcd3a9d56564159399a33fee0e504"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8e9469126a98d8041fd8b093a8df0f929cbf97ececfcc9e80b7a3d79df3b27e7"
    sha256 cellar: :any, arm64_sequoia: "40f012d8e0e7f63981808b5661449cd4fdc0e84b588e49ea32de91ce2321435b"
    sha256 cellar: :any, arm64_sonoma:  "462c46b3dbc6bbf23128e7a323906818700aebdab5c80c7bf82bc680ee3d1f93"
    sha256 cellar: :any, sonoma:        "969cf3e7a55a06e227c165f0d155c28d63c1dfbed321c57a1ee06f3f64975cbe"
    sha256 cellar: :any, arm64_linux:   "b6382871174cde2b776ff6a79feef7431706af8d3a73302f284b23ac867eb128"
    sha256 cellar: :any, x86_64_linux:  "378481561da9a13eafd6e87e32aa5ec0c4570c42cbfd9a4c0b2426f9b0215ffa"
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
