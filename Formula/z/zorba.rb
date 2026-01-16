class Zorba < Formula
  desc "NoSQL query processor"
  homepage "http://www.zorba.io/"
  url "https://github.com/28msec/zorba/archive/refs/tags/3.1.tar.gz"
  sha256 "05eed935c0ff3626934a5a70724a42410fd93bc96aba1fa4821736210c7f1dd8"
  license "Apache-2.0"
  revision 20

  bottle do
    sha256 arm64_sequoia: "531dae378c0007fe5b28d122ad9e03158f87653321070f53fa7a8016125611b7"
    sha256 arm64_sonoma:  "7bfa2637276cbc0fbade2f450da1b68e88fb7aedd944ce83a658014ac035607e"
    sha256 arm64_ventura: "b8760ea3d7df545813b9f333fcf49c6dd9187558b3701e281383336a3e62c674"
    sha256 sonoma:        "368e4b11f65d08b39c602a001f26719b491d92b03ac98de86719d7a86ddbdcb5"
    sha256 ventura:       "7b79034310f8f4f18b21d777540d03279dd7de8ba6e9950f722ca2b93439992e"
  end

  # https://github.com/28msec/zorba/issues/232
  # no longer build due to `'boost/filesystem/convenience.hpp' file not found`
  disable! date: "2025-05-01", because: :does_not_build

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "flex"
  depends_on "icu4c@74"
  depends_on "xerces-c"

  uses_from_macos "libxml2"

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
    assert_equal "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n2", shell_output("#{bin}/zorba -q 1+1").strip
  end
end
