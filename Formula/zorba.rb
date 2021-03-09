class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 13

  bottle do
    sha256 arm64_big_sur: "405903292b2d77ddbeae81e4ff1fbd3607b13d63151e3323b6e27d6e846933c0"
    sha256 big_sur:       "fdb93db4639dbbf62e667e9c410f71f16f6a04cc0939735be21ed07ed25ace05"
    sha256 catalina:      "4fee87469b0b2d87613b182ea0fe44d1ab12e391546e27a29c5a58ea6e89b757"
    sha256 mojave:        "7d5d0823314c789842615b6b8339a1c7b14521cdf45b8a682f3b796660dc0f5e"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  uses_from_macos "libxml2"

  conflicts_with "xqilla", because: "both supply `xqc.h`"

  def install
    # icu4c 61.1 compatibility
    ENV.append "CXXFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    # Workaround for error: use of undeclared identifier 'TRUE'
    ENV.append "CFLAGS", "-DU_DEFINE_FALSE_AND_TRUE=1"
    ENV.append "CXXFLAGS", "-DU_DEFINE_FALSE_AND_TRUE=1"

    ENV.cxx11

    args = std_cmake_args

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # usual superenv fix doesn't work since zorba doesn't use HAVE_CLOCK_GETTIME
    args << "-DZORBA_HAVE_CLOCKGETTIME=OFF" if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

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
