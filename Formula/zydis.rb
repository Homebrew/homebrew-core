class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis/archive/v2.0.3.tar.gz"
  sha256 "9a49b179ee2c787e1887e789867ca5c3a6c5e1fc929548c0a64f81272990ab01"
  head "https://github.com/zyantific/zydis.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00a9d49fa9a542eedd2332d14134c92b6c4022547bcd65a74db2797d43964afa" => :catalina
    sha256 "30e492d8005033bdc38a2fc2b32573ee7f8567484d516cb39f9edd094ec2c9fe" => :mojave
    sha256 "77aebf0f3ab130504dabdc08d54fcb1cc5748eaba01fcea3f7a6558a0e6868a3" => :high_sierra
    sha256 "846e26eb8120db0797a69b8335743aa95d3feef9cacc5e04aa7a2ce21cfa84dc" => :sierra
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
