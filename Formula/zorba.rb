class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  revision 9

  bottle do
    sha256 "cb24e884cb56af293bf9b10e7280aff091e72540d6d67d610674bcd0c5dfcdd9" => :mojave
    sha256 "35316a8148a7c4b89be1b2acbfc891541cdd994d535764db5ad88b858b99f8b0" => :high_sierra
    sha256 "167fd942d96909452d63be186c76b0f2c9b8d575b9afcb896b6d7ba15c4af798" => :sierra
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
