class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "e292eee32ed93a5f102c4259fca073109142f41033b4263f51018bcf1e29eb10"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e81765624c5d52476d0592ec2546c2971a90457928e30e1820657e8ca35a6b59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0860f59f12f3dacbb8d3209162758085756725d2ed08f28e33067f01437e396d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a299911963e274512ef0b9bfab0015533939168f6535b5c921586f4c16fd37"
    sha256 cellar: :any,                 arm64_linux:   "5c3e3f686c6e2f2a16a15a729ea22e4e0d3b0dc2866d1de8222ad90182ecd762"
    sha256 cellar: :any,                 x86_64_linux:  "c2ff82e11b120a4d28a6175398bb06aeb789f6a5ae3e34cf5f30bddf0db269d5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
