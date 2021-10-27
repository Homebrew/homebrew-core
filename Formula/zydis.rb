class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis.git",
      tag:      "v3.2.0",
      revision: "95365aec6927c36ecad33cc543430ab214260dc3"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49b61da77b2bc62fd900cb335e3d0c36093c5abf5dde65814f4b83a9a419856a"
    sha256 cellar: :any_skip_relocation, big_sur:       "caf94bcb4ccdf9cbeb849a614837264e8bcb5413ef1353ad9da20ebcef7d51d9"
    sha256 cellar: :any_skip_relocation, catalina:      "f4b7cdfca8bf8d59843b75d493401b04a917a372658fec079db52e0ca1485a69"
    sha256 cellar: :any_skip_relocation, mojave:        "9cbfdefca894dd7822f0a4d2d7639cf80ca24c0684d99338b84de04e317f3de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3b761232a189fe07888abdc73e5cffac07a4502d5af03a4223205381d21466"
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
