class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 16

  bottle do
    sha256 arm64_ventura:  "9965ca51a03f06f62ef2f88cfcf6d678a4a0a79f63a1b5d4df79fd7d6065f061"
    sha256 arm64_monterey: "46f70d378fe9bb29b11e1e8c36a89d6e87a8edd31506414d7bdc898ee9a38f3b"
    sha256 arm64_big_sur:  "1ec7839bf4f2c5c894ab97e022af5299411509da28b0591f5fa317cfd6b90cfd"
    sha256 ventura:        "17314361ecb78dd79b6bf0a248da0575c2bc7af209e21edc2944a427465a501f"
    sha256 monterey:       "e7989cc9ae5f1f69ec450cbb266eace9e9b69040360b087dd9e1f9b960429207"
    sha256 big_sur:        "df9a7d6bd090be66e98299e32be821425ae0618ea3f865e5a3da9967149b2fb0"
    sha256 catalina:       "3edcef6b795ce703533f54ebe944a8f0ecfc05211e3fece3d5275d887544aa56"
    sha256 x86_64_linux:   "4cc2c7b15623b2ba658a0a50a9556d905aeb5a4f3824f713b74709f86266a89e"
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
