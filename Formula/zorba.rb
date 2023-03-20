class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 17

  bottle do
    sha256 arm64_ventura:  "0f8d3555ffae2a128f1a9ad32fca31461aae65139bd541071c1aa36a82a9cc6a"
    sha256 arm64_monterey: "4b644d7087be072db21516a838b8cb885f91875da6497d608b2d6960615c68ae"
    sha256 arm64_big_sur:  "e0e9321d237f63c206641cc46841cff8cedd331b21d97f87b820e69ee03640a0"
    sha256 ventura:        "a2b6c6f68e998ef0b8b848f15599cff2296f42f6f7b768d8174cfb883f7aa0c8"
    sha256 monterey:       "1ff78baa07f19a14711c2ceed7516dcb513580544c61cdf85ecb714f74c325dc"
    sha256 big_sur:        "8c73ef3aae0cb40406c2e06863753c847c117bd1c67c6a414b3f9e739463e975"
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
