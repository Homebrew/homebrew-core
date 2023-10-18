class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/0.14.1.tar.gz"
  sha256 "afb2d120722141aca85f8144c4ef017bd74977ed45b80e5d9e9614015dadd60c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a931ab5487ccabced3f26df631417cfd44f40484eb58234c020538edf73bad37"
    sha256 cellar: :any,                 arm64_ventura:  "97ee9063f01dfa304494526e1065a5501bd9ee752219c8bf0c1dd9625c44d15f"
    sha256 cellar: :any,                 arm64_monterey: "db22830bcfb4f23985c5d2a2910a134fcf4f903a179a8df7f834f5c56577724e"
    sha256 cellar: :any,                 arm64_big_sur:  "7b50ac138ac55465f204a745f98e53af68f0bf78fe3bb368901284ec7dbc5e33"
    sha256 cellar: :any,                 sonoma:         "cf3b1d4d820887cfc5645cd67959bca60cff4309d030e7dcc3c31f782993b395"
    sha256 cellar: :any,                 ventura:        "a4a3d37279e7c59f591e40b3022d622c18398b744e1dc3937d6a80a74ba085cd"
    sha256 cellar: :any,                 monterey:       "7f33800981881204de55f9d401896f9dea8be17466ea39e9940d18591d02c80b"
    sha256 cellar: :any,                 big_sur:        "a797110599496bc347e32294d2cddab2dd2e6d916233b445ef508377d613eaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8554a2961feee2132fe2393c8142a13562930ab7a2e51dd331c0ac78f6eb9f39"
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
