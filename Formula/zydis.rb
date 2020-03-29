class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis.git",
    :tag      => "v3.1.0",
    :revision => "bfee99f49274a0eec3ffea16ede3a5bda9cda88f",
    :shallow  => false
  head "https://github.com/zyantific/zydis.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ceffe3459006c374498e06809f8d75e9f512d5a43482d9b4d3973bbe4b2e3944" => :catalina
    sha256 "a51c744f89ed204c66e0699a960a3c58625a5f46f16f3710e68a4746bbc0fb7e" => :mojave
    sha256 "cefab7b097b79ae4c04616c235e572ffc5416296eba2a10bd7b07c6f18148313" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/ZydisInfo -64 66 3E 65 2E F0 F2 F3 48 01 A4 98 2C 01 00 00")
    assert_match "xrelease lock add qword ptr gs:[rax+rbx*4+0x12C], rsp", output
  end
end
