class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "7fc1efe81bd4b25b6271f6bc30d2884567bfe7360cffee2992629600ba5b04f3"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f6f30e817bb63ecb30acd1a6c53a1bb025d87d610e66162618875a661637c41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c28b0e412c1109e4c79e3144e51302be8b8992704e943db36a54e0c7e0726c63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eed6545406729118c927202f5dfe5ccc13a87f650de9dffd9131c2956daa40f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff56d625d25613301ce37cbfd631c978668b56355396f9ba5996fab477def3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a59f9c07a52a384c8fc57f1e3af5468da09bee3e7b7975afd8919a31853c7778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f159fa1d5c4d31e01f0c47c02e4ed1b329d2da42c3e5f0bcc50440fb59957ec1"
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
