class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 15

  bottle do
    sha256 arm64_monterey: "d52b2aa6b6c0628c064cfb6e485b691c6fab705ef896067e22195e0cea3310b1"
    sha256 arm64_big_sur:  "b80b156d8ee91bc06d0d813bdf9e1f4bf15c21084a6c16a1749d25fa9222e49f"
    sha256 monterey:       "24180554c7ab32f17c200c0449cf84edc53e55fbcc7521ba54cdc664dc57d1c9"
    sha256 big_sur:        "abd2c1bf5b37980d577e3e4813f36dfc8ed9ddb1cfbbc89d4ac4a3c84353fb43"
    sha256 catalina:       "25f7600f74bde8eddaa0201b177e2fdf1d58d3e6642824caebf8117e69da9b53"
    sha256 x86_64_linux:   "1ff07ad15f4ed840dcf1faa096b6c9bd30e3f78cb778e3da656323dc7ce0a598"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "flex"
  depends_on "icu4c"
  depends_on "xerces-c"

  uses_from_macos "libxml2"

  conflicts_with "xqilla", because: "both supply `xqc.h`"

  # Fixes for missing headers and namespaces from open PR in GitHub repo linked via homepage
  # PR ref: https://github.com/zorba-processor/zorba/pull/19
  patch do
    url "https://github.com/zorba-processor/zorba/commit/e2fddf7bd618dad9dc1e684a2c1ad61103b6e8d2.patch?full_index=1"
    sha256 "2c4f0ade4f83ca2fd1ee8344682326d7e0ab3037d0de89941281c90875fcd914"
  end

  def install
    # Workaround for error: use of undeclared identifier 'TRUE'
    ENV.append "CFLAGS", "-DU_DEFINE_FALSE_AND_TRUE=1"
    ENV.append "CXXFLAGS", "-DU_DEFINE_FALSE_AND_TRUE=1"

    ENV.cxx11

    args = std_cmake_args

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # usual superenv fix doesn't work since zorba doesn't use HAVE_CLOCK_GETTIME
    args << "-DZORBA_HAVE_CLOCKGETTIME=OFF" if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal shell_output("#{bin}/zorba -q 1+1").strip,
                 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n2"
  end
end
