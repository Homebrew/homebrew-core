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
    sha256 "d739cceae8b2ce55beb1909148c5f55dcfa2082790dbe0d83a0dcc5373551bc7" => :catalina
    sha256 "8fa67ea3f233d3b90f13043f4259229fb8208a9a3facf1d42f807b50db17548b" => :mojave
    sha256 "57ce062f4a98498e13ba4ee5fb2691af2cc43435cb6097d478d72d838eeff039" => :high_sierra
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
