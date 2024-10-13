class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/refs/tags/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 19

  bottle do
    sha256 arm64_sequoia:  "c748d5b310b5949922950639ab308a570420a1814ac18791afd40fcee4748c29"
    sha256 arm64_sonoma:   "76020d9803bf9f2c53dfe4abed2556ecaffa1a76da175c3d1212798b4b6bb5b4"
    sha256 arm64_ventura:  "1d4b6b753efab82657b360c0e2c7a42ee1b7b4e4ce9b3a36175a6986bdcc70dc"
    sha256 arm64_monterey: "d76750b3bcafe33f0a73276d0f6f1af6e4e20bc852c9051d5721bba72847545f"
    sha256 sonoma:         "888b611e99c01579f1766d2a4ac32580b67e8720eb8fb16f2bca1734da4ee131"
    sha256 ventura:        "52dff33ef2a07234108bfa1ae7f7147d993f1a1fcf27b9d4be36b5a587f22b48"
    sha256 monterey:       "65458012718d8c612cff221ec17e165504d6db79692fcd860a0cf4b757bac5fb"
  end

  # https://github.com/28msec/zorba/issues/232
  # no longer build due to `'boost/filesystem/convenience.hpp' file not found`
  deprecate! date: "2024-05-01", because: :unmaintained

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
