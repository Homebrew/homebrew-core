class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis.git",
      tag:      "v3.2.1",
      revision: "4022f22f9280650082a9480519c86a6e2afde2f3"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cda576fd8a15844bc23d45416e7af7c11911caa13bf079a2e8beda0636b815b2"
    sha256 cellar: :any_skip_relocation, monterey:      "b1f6b23dbb37b6f22f4073f8307d20a9a5b5d71f6d1cd903c58b003ffff7e7a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "e920fabe882010a8cb9f9ab06e665a4e0ebc11b6938f164ce88f5df6c4c95206"
    sha256 cellar: :any_skip_relocation, catalina:      "3f7f89f59c2b0b998a5d5b8a2c95230b0946ff8c5ad0157bc8c7db7e5f670ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ecade881925407475f39e351262f5d95bac6e8775978f6cc50d3f841a7be4e3"
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
