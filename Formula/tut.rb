class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.24.tar.gz"
  sha256 "9d4f75dbf5a7d1ad9e2857838612a507eed4d297cfdfe59bef48856127bb6efb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "277e4858ac409150fd6ea34985844bcea8c3e59df7df080e3ff21058c486eebd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74b152afe9ec6510cfc781569955237ff3e72a2265bf4c8bc5e041f2473ff2f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af14efd2daca9e14422ee88f3d9c18e6db7ca82a4c6da51cdbfd3efb450bf3a1"
    sha256 cellar: :any_skip_relocation, ventura:        "14b21a4dc834da8587725bf87f1f3956059ed96053490e9c2b35b38a77539173"
    sha256 cellar: :any_skip_relocation, monterey:       "f8409f94a116b855ec87c13aac5f757ad3f4e79a39dfef93f68e2f219071c35c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb43fccc05f721020c6790effcf23992d44ee3422bb1d7fafb63d6cefe1b361a"
    sha256 cellar: :any_skip_relocation, catalina:       "b4d5d18a2342f119890195406bf00e1a0cd8d269ebc6d55cfcd1f8e8508b94f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaad8961ddc938a8d844d1e8bf7de8395679d525bdcc15d55272bc8d249f78b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end
