class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "e0f39fbccea7150820cfef84df4525c0b1959315a281892a72438e250187aea8"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06fee995e54e0d3f4062551d3d4e3cf87e116440372e281b64e3858b2b62d5dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "364b664fb8297f309ca1d09865f45c7a3432a9d6db38246ce29bc3e59d743290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54d2be15aeb2a25640867aa60f87efea9a36e57fca5532a22ce97fe34f3c8a45"
    sha256 cellar: :any,                 arm64_linux:       "403a7e588057ec3dc22560b1508de1b6765cbe708a99e8f22c98e3f097082918"
    sha256 cellar: :any,                 x86_64_linux:      "347de80180c805547a23050ea9dcfe1dbefaacd16dfc62a1ec648e14a087f164"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end
