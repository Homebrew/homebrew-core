class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "af19b8644ff92f3b38d3e75b89ce4632501c102f17f32b09d7dcde0b27e1c16e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0983399df2798c7d5688b57679608f558bd90373e840f3dc1656ba53d6ebad41"
    sha256 cellar: :any,                 arm64_ventura:  "ab54710564e207a8ad5e7e04e99f26a76976f4923c7e0f15b4dfd2ba835473dd"
    sha256 cellar: :any,                 arm64_monterey: "29b1419f44424f70ae15ce2e550ab57229f97504b16e9f24e6ccc753f064f8db"
    sha256 cellar: :any,                 sonoma:         "f4590bbe048849532d321ce65bd9e149df4338521a8a582e2cd9e5ba3691f3e6"
    sha256 cellar: :any,                 ventura:        "380905be46ecd5e75d0b22cc1b26afe0d0c4ff6668ab0edb4f2467f9ed96580a"
    sha256 cellar: :any,                 monterey:       "78469bdffbe5cd7dd08fb14df66c19ed568c5f1af25b2459fc3cbbab6a188533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6010b3d859f8725ea0da5e3ec9bd05003288e25b917ab0bd40bf40783eac4f56"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
      LIBS        += -lQXmppQt6
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <QXmppQt6/QXmppClient.h>
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
