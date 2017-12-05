class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  revision 5

  bottle do
    sha256 "ee24c449fc98d27f3c2e2152d35134a8d74e0ddf4c9228b3461de7865e8ad2d2" => :high_sierra
    sha256 "5eb5fe051c6105ac382d3de6dc6ac519d39582fcadfd2ae84d034f48e92c40cf" => :sierra
    sha256 "ec054d47fbc4b1bfd4709639d0f940880f3e989c63e6deea33ef30075f091e49" => :el_capitan
  end

  option "with-big-integer", "Use 64 bit precision instead of arbitrary precision for performance"
  option "with-ssl-verification", "Enable SSL peer certificate verification"

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  conflicts_with "xqilla", :because => "Both supply xqc.h"

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DZORBA_VERIFY_PEER_SSL_CERTIFICATE=ON" if build.with? "ssl-verification"
    args << "-DZORBA_WITH_BIG_INTEGER=ON" if build.with? "big-integer"

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # usual superenv fix doesn't work since zorba doesn't use HAVE_CLOCK_GETTIME
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DZORBA_HAVE_CLOCKGETTIME=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_equal shell_output("#{bin}/zorba -q 1+1").strip,
                 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n2"
  end
end
