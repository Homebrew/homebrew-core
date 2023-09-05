class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 18

  bottle do
    sha256 arm64_ventura:  "97f108986cb35b6a09113fb9fb18b5e40e6b2321212981ab1eeeedf8830fa46b"
    sha256 arm64_monterey: "c1a3ea5f34bb0523a68124e5f40a95e9048b063c37cf041363fe71131efee4e1"
    sha256 arm64_big_sur:  "785f9a1aa5f5e2823c8bea4b1853b43af2817b407ebbd54e8dd863afe1b398fe"
    sha256 ventura:        "c3ab863eb030b2adbc8b033040319b67cc0fe9a93c1c97554d5347559a66d183"
    sha256 monterey:       "0ac8239e4e37f74590940e3c5f8e37202aa6942cbf241e3d5827241c205a7faa"
    sha256 big_sur:        "a4baa74dcb62830f6bbc21a224fece87287d372b9ab1deffd3c3b437929073b6"
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
