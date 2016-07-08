class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.5.2/qbs-src-1.5.2.tar.gz"
  sha256 "059b4f64c1f599379a17bbf859dd9658fafe8cb2b65b31634974ff1c381928c1"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "e39b47873bab7ad8f027cf4de0eca034e67c0b52f8494d91eab7115247dcce86" => :el_capitan
    sha256 "dacd80266a8cb10c39d283c1003d0b293e8e5e2ded1332e9320d455a82af689c" => :yosemite
    sha256 "a6d9b4889eb86fb3649458ab9fe1ffd21249094aec5e3b1f13076ac1e8ee5b21" => :mavericks
  end

  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=/"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbp").write <<-EOS.undent
      import qbs

      CppApplication {
        name: "test"
        files: "test.c"
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "setup-toolchains", "--detect", "--settings-dir", testpath
    system "#{bin}/qbs", "run", "--settings-dir", testpath, "-f", "test.qbp", "profile:clang"
  end
end
