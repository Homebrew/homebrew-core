class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 15

  bottle do
    rebuild 1
    sha256 arm64_monterey: "e27b8ee893f4bb7c428a34c92665f9ef7a1e2fd121197acde433afc8a38040e2"
    sha256 arm64_big_sur:  "be6aa751dbe3d108bb39fcd8bcdab9006b3ca1ca9680242b0da3dd8933ad74f1"
    sha256 monterey:       "b260f705dc1d3ece53480160273003dedb98fe5c0806fa3cfc311c9c599b52ce"
    sha256 big_sur:        "6e2a8dc08bf94709be952db4c1e4a791faf2d8c199441ca32bee457c46fe12c2"
    sha256 catalina:       "2dad59eb368c4d9480f68265441ab8899d8eddf1d2041f934ad22801bb6bcf2b"
    sha256 x86_64_linux:   "c5f0f199ddc34c3c6bbf5ac55d8b5bca6da6428684ed3f2d930a5d442c85863d"
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal shell_output("#{bin}/zorba -q 1+1").strip,
                 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n2"
  end
end
