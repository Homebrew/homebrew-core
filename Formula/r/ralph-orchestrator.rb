class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "53334813b0c7cbfa3759a74a15c001930a4aea33ec63228467582f8e78819520"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f14d5f011b4dfde7462c6d6f016434802e8d76d5fe222c48d918ebd7b60171e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17ec812e104879b6c04ddf63cb0b839c1d64c0fa29165ef8c2136870095fbd30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d419f447c4fc36a972773b8bae65362218c8a66db5f586ba711ceea54a9193c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e2cb7e91271a2136c3826173eb0d72a8c5411ae7c903d66cc6978177aa423e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f61f0a034c4cafa3463d56be75ce93d5f3a37f420144c9476834dd45aaa49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bac7718a892a088d4a3f13a3a6c4301ffc569c885cc7e001196363a3aaaa47a2"
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
