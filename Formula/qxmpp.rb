class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.4.0.tar.gz"
  sha256 "2148162138eaf4b431a6ee94104f87877b85a589da803dff9433c698b4cf4f19"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "c6e0b95b7721e98dc3a507539394fa2f083aed77193b48ed412c690f4e1d1627"
    sha256 cellar: :any, arm64_big_sur:  "6399d05b012c2b52345d45c1b4cce465e36fdefd3a1a8adf44f19626feacaffa"
    sha256 cellar: :any, monterey:       "e4a1a87c3de039fd3f7fc6c89c0f8f1ac75764bcffce54c18af07854632030ce"
    sha256 cellar: :any, big_sur:        "97d09f017f500de731726453d7e7780087beb963685745b0fd92c30134fdbdfc"
    sha256 cellar: :any, catalina:       "62795c2f2b6a5c39f5bcfbfeac06a5fa48a289962dce4abec095dc937f237470"
    sha256 cellar: :any, mojave:         "a30dcbea5faf9369d20c51e0c5d8c743d8f6ef3d3f1527308705041d58138e77"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

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
