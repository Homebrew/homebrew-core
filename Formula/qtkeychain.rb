class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.12.0.tar.gz"
  sha256 "cc547d58c1402f6724d3ff89e4ca83389d9e2bdcfd9ae3d695fcdffa50a625a8"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "bf0b64428ab4c68950776274f1f3e8c811c2faa349b7b46e87b846c9aa7e28f6" => :big_sur
    sha256 "a62fe577bea556b1163c5646847a73a7b63b2fff511bd3bf53dae09483cf7b87" => :catalina
    sha256 "097c36e47620aeaed901b36cc7d9e576e27e4f00412276c56b052f00000807fc" => :mojave
    sha256 "ffe9a1a012f7a8b4b09dd268769567ce545c22f2eb0484662ea8e48c8bffb9b9" => :high_sierra
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
