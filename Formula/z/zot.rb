class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.50.tar.gz"
  sha256 "cd88ec3db30c88005667d9f504eb16d09e0c14542ee389acf4d788aefa5aa5f7"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee960db08ff406a182ed58669b5e6ee5b2df605f551c733597ea7726e45be6d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee960db08ff406a182ed58669b5e6ee5b2df605f551c733597ea7726e45be6d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee960db08ff406a182ed58669b5e6ee5b2df605f551c733597ea7726e45be6d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a716059776d07abc359212daf56e06c5fb4ac00a8bc239ab35af093a995a7088"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eafa7aca8c79f9731c2e79848be9b9fc027ee9827bdabf4658a79f9f1ba1a7db"
    sha256 cellar: :any,                 x86_64_linux:  "0b7d7eba55821b43ed9e899c1a2c86e9fcff9296b23dbba2a0b4e3e0d57a4d26"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
