class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "45c6d4d499a1cc80780f7834747c637509777c01dca1e98c5e7c0bfaccdb1514"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3d64cf57d8e2eb55ac2457d12c35d227cca34db9c480d0c7fe6e41fd207bacd2"
    sha256 cellar: :any,                 arm64_sequoia: "be71db07f686d7a09c8db9171418d0f8b0fbe3129f02b32b4d2fb956be023a6d"
    sha256 cellar: :any,                 arm64_sonoma:  "3f74e22ca0befe90b33a8682e243c4ad4faad8e05ed730b5a320d5fd0426b27e"
    sha256 cellar: :any,                 sonoma:        "01ec1f6ed5fb736d90dceded3f6ce60e79a97749441b1974d74038fec675ee62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfcb9abc2e3e2787212e9f9d3f2325730a33405e07567d2d0b67a4b82657b797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb5cf27e4ef3db8977e70c0f33f9aa71da5ca8140769cfdd13e65925ca86c4d9"
  end

  depends_on "cmake" => :build
  depends_on "ronn-ng" => :build
  depends_on "zycore-c"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DZYAN_SYSTEM_ZYCORE=ON
      -DZYDIS_BUILD_MAN=ON
      -DZYDIS_BUILD_SHARED_LIB=ON
      -DZYDIS_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/EncodeMov.c"
  end

  test do
    output = shell_output("#{bin}/ZydisInfo -64 66 3E 65 2E F0 F2 F3 48 01 A4 98 2C 01 00 00")
    assert_match "xrelease lock add qword ptr gs:[rax+rbx*4+0x12C], rsp", output

    system ENV.cc, pkgshare/"examples/EncodeMov.c", "-o", "test", "-L#{lib}", "-lZydis"
    assert_equal "48 C7 C0 37 13 00 00", shell_output("./test").strip
  end
end
