class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v1.3.1.tar.gz"
  sha256 "812e718a2dd762ec501a9012a1281b9b6c6d46ec38adbc6eec242309144e1c55"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "98e9f506c62ab3b25d0de4fff745309eb36f99230910e83f8258a4853b8c99f9" => :big_sur
    sha256 "ae5ada2da192e552193487318f63c28bc5a1ce71705ac97ff2f2cdaebf1ace20" => :catalina
    sha256 "ace2c4096387d98f5a27d28d73b0ed2453a61a5a9b4bd7ff1c55b105f0373b38" => :mojave
    sha256 "a8342df624addc888a2d409e01a087e7974ff78b2091df7f6dc94949bb55abee" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
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

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
