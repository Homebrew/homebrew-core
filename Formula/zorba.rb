class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  revision 8

  bottle do
    sha256 "a24259b380ad74230a29a68a0166f9c88832a69d1c62e941a2864102df88a848" => :mojave
    sha256 "1ee6bcb9160599deba3286a3a32e6682c6ab9f49dd29bf3f2b7379799aa4461e" => :high_sierra
    sha256 "0611b46146ef4e6da55d5c8a2e37c9df60eab408abf0c71b86a702e4825120a5" => :sierra
    sha256 "9dc07aa5daadc49cbbdeee1fee3ef14800a604069e996859ec58b441c1738bdd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on :macos => :mavericks
  depends_on "xerces-c"

  conflicts_with "xqilla", :because => "Both supply xqc.h"

  needs :cxx11

  def install
    # icu4c 61.1 compatability
    ENV.append "CXXFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    ENV.cxx11

    args = std_cmake_args

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
