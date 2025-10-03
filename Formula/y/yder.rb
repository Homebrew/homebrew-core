class Yder < Formula
  desc "Logging library for C applications"
  homepage "https://babelouest.github.io/yder/"
  url "https://github.com/babelouest/yder/archive/refs/tags/v1.4.20.tar.gz"
  sha256 "c1a7f2281514d0d0bba912b6b70f371d8c127ccfd644b8c438c9301a0fd4c5f2"
  license "LGPL-2.1-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9f885260fb16abe855f8334ab2c1b6bddaf032e7e19e1a119bf9ba6280b8e784"
    sha256 cellar: :any,                 arm64_sequoia:  "742de6bb638644e32ac9153a26fb2cecbaa8575b765ab4166221389efc71b80e"
    sha256 cellar: :any,                 arm64_sonoma:   "17f19f57371282f824f622fbc956fbdb620cc2f41558e2b7a046ee80afab7594"
    sha256 cellar: :any,                 arm64_ventura:  "1a40a4adeff343167112cb5887cf8e91bfdcad589eb56197d4b3ceffa38ac6c0"
    sha256 cellar: :any,                 arm64_monterey: "4619ff198f36c61f6f6602cb33ef2f440eb69d694fcd9cad88f8f9d82db9d028"
    sha256 cellar: :any,                 arm64_big_sur:  "e51598adfcc0c641c45d1e607273facdb5bc0e5cc094433e65fe572d9f94a324"
    sha256 cellar: :any,                 sonoma:         "699d2dad4ab3e4ee74be1e3a65e31cfa803efda441726b7f246ce7f77c69b647"
    sha256 cellar: :any,                 ventura:        "b97d5bf7aed879840df320ee2882d84553578332e362cb21cc1e84d178c1da66"
    sha256 cellar: :any,                 monterey:       "87580769714792e35280df4f0980713d5ddf488df13255ce7622e1f99b7549b0"
    sha256 cellar: :any,                 big_sur:        "03aad7c58b6f0986ff11160e37bca013eabcf67673f01d4c667b603e1820ebf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "94e170cd9620c2ca378cd7e30d6638c2a7dad5c662757cf6121f5810f1f4b3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1b907e430a7ac5a0b6c610655f0254943c3c3f4b0e1a31e59bb787223d4872b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "orcania"

  on_linux do
    depends_on "systemd"
  end

  def install
    args = %w[
      -DDINSTALL_HEADER=ON
      -DDBUILD_YDER_DOCUMENTATION=ON
    ]

    args << "-DWITH_JOURNALD=OFF" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <yder.h>

      int main() {
        y_init_logs("HelloYder", Y_LOG_MODE_CONSOLE, Y_LOG_LEVEL_DEBUG, NULL, "Starting Hello World with Yder");
        y_log_message(Y_LOG_LEVEL_INFO, "Hello, World!");
        y_close_logs();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lyder", "-o", "test"
    system "./test"
  end
end
