class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "a0fc596fd2b8aabac222e22e96fc02709e185031e31a15b522f4c5c59db892d9"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c643dea5e6c824d0b4f06c73c67dff32ee827d1776302253900d8c7d9c4044d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b5d0d1cf999cfcc22bbebd741c53b98a6a81424ea66f9a90febc9063cdef108"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95202bcfe4f1d85a97b955a117bde645e4650e0f982dbebd6a72dbf7b52dc770"
    sha256 cellar: :any_skip_relocation, sonoma:        "c028056421ac64b94c3827f920619352e6259bc4b1d730ca538caf5e4cb8d442"
    sha256 cellar: :any_skip_relocation, ventura:       "0504fb167b74348112c66559ab2b62c50972b8e1ab5074ea0cdcc1ee3948e1a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fbfa365ba4f253cac822126467ce068c64e95c03228ca5a2c0c4227d7d5d060"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt --provider pollinations \"What is 1+1\"")
    assert_match(/(1|one)\s*(\+|\splus\s|\sand\s)\s*(1|one)\s*(\sequals\s|\sis\s|=)\s*(2|two)/i, output)
  end
end
