class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "7d2376aacd145ad8e734cf0af978a014ad8fe00d5958d49c6f8cde171ad8ff13"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1945f6c065e97e1f64e21287c2edb1f4b891ac0f99ae35a9a0c716319f4ee17b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa39a86d238b0d28b95dfb2196e334568f672351947f884f0df5170001164b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de14b4b4431e009a284b76c3ad260a7c2df9f804933840e743bb4e0f526641d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a694f0d82643ce6ec1ba75e0800ebd69170f3f6e3a1f97e906e63ec21444ee66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32d6b64b51910e8264b83a6d6607b3140bd0d60655082427183b74fc42ecb56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3477a8fbcb41ce8bc317f8245bb7f026463ba04cc0516899264e2c7efeff59b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end
