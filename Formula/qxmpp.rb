class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.4.0.tar.gz"
  sha256 "2148162138eaf4b431a6ee94104f87877b85a589da803dff9433c698b4cf4f19"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "a45dee27f1476a882f3bb9c813c50ca7ade0f8746e3bb5597d17f0ac5e556691"
    sha256 cellar: :any,                 arm64_big_sur:  "6899676686e3bbe23b37d8d55c80f732ca0cf9d8da93c184957d278be653c77a"
    sha256 cellar: :any,                 monterey:       "c2ed7027d5075c6963d352978b1f314e93b2d7625fc1390276dbd0888403bb5d"
    sha256 cellar: :any,                 big_sur:        "10b61feb8873148644facc80cc794e7d5a942e25e2e340dd60345e8e9d336cd0"
    sha256 cellar: :any,                 catalina:       "9134a8266be698258ba7943fc19b662c4c056c96465e50d7bae34a8d8181e8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e34f0a44f98a1810af111a56841d7964204d2924fa4b8b3d78309d6c1ee81f"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      QT          += network
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lqxmpp
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <qxmpp/QXmppClient.h>
      int main() {
        QXmppClient client;
        return 0;
      }
    EOS

    system "#{Formula["qt@5"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
