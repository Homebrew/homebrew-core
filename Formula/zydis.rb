class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis.git",
      tag:      "v3.1.0",
      revision: "bfee99f49274a0eec3ffea16ede3a5bda9cda88f"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "914a4009a2c3ee6e7b039574f2b294e919571b68d4e7687a3c01c06e16c4f36a"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6625ee8f3c5e9943e9168cb788fcbf9aa6751c288bf3f00c71aa49b5baa1754"
    sha256 cellar: :any_skip_relocation, catalina:      "ceffe3459006c374498e06809f8d75e9f512d5a43482d9b4d3973bbe4b2e3944"
    sha256 cellar: :any_skip_relocation, mojave:        "a51c744f89ed204c66e0699a960a3c58625a5f46f16f3710e68a4746bbc0fb7e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "cefab7b097b79ae4c04616c235e572ffc5416296eba2a10bd7b07c6f18148313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32dd9b3a1efafe0d3c47a7c74677781d93e8af4d9786a9367c17209c24216ce4"
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
