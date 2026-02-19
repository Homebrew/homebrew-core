class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "04acbfe42a5f794ef85db734a1685ab1f86bde5b04c5dd0625504cbe1fa48161"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad6305c174f40670358c009d3376017b2f54c4abc269ee52bd096449d64d784c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1aaf08e0b03161ced205741c03e04a8d925c7534621702fd86ad8fa933d5ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a3e11dda3bf3fb9778150ec30f5a0c10e009c1527cd0159396061b82679585a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4b456b506c70d6feecf60ea3f0ff6afb0f511f92336470f2272c219afbacad4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "590f78dc11c18606c1a72bb538862930615a30565370bb2d2d705169a3b35da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "055c68a503eff157d509cf499b91f8c57dc9dbeb8bb63d9aadb0809f86a7ba6f"
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
