class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "b0234452276a764c1601b237bb27d3b6205cbfa5fb8e727d616c8d6b52e9c59a"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aee012eee1900a1cc5070af9244108292b16302dd9b7b3932d15871a28809161"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "910e19a8507348b19931ace2d1d362bf701553970cf352c1c7ee41b9a4a36f21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab21f0b1afdf2efe0836f0c07aceb73ced9ca4399d9719c05e52e5e8a4acacd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "df1123e16a7a71795d428732405a511d38fbcb151ea8184a5f3642ef02bef208"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8f733dbb197fd52ae6ea761a2d10a2dc5976c0d04303f7327be49aad03f1356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20e4afa14454e74567a9d9dfad075af6d1aaff20a813cae6cc2d949d04185eba"
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
