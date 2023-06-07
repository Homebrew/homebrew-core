class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis.git",
      tag:      "v4.0.0",
      revision: "1ba75aeefae37094c7be8eba07ff81d4fe0f1f20"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b70bb8aec9d6f049046a37de51972c220408f747dde8881bddde7006f54d4371"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "151c4579826dace15babff8ee96994a477927c84dcf0345064c4af5e6f796fd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfda85213ebb2135914d60fb36c82f401ee463f8adb6142a6e5d8a930724f3f8"
    sha256 cellar: :any_skip_relocation, ventura:        "fef2143f964ad8a5ffba4e7ba1c1905060bb312f94a7832042ab54c98c0936a6"
    sha256 cellar: :any_skip_relocation, monterey:       "a22ba879337f31e0f67b0938567b80e6c84c6db2fdfb4b6024399029862bebe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bfc2b206264de685d541f6f83c735d2dc1e98bf854884415b07e7cc23eba8c9"
    sha256 cellar: :any_skip_relocation, catalina:       "01e219ba0e015f596bcd44ebec6a1b9311b3db6108db23ab9329ffb32bde08b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70750d47ee38a79417d6a490ac7ee63c7e66911f29d185698e7467ab730da8bf"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ZydisInfo -64 66 3E 65 2E F0 F2 F3 48 01 A4 98 2C 01 00 00")
    assert_match "xrelease lock add qword ptr gs:[rax+rbx*4+0x12C], rsp", output
  end
end
