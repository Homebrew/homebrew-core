class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "4c90282906ee5886b486815d4e9a33941fdd70e60569eb4fc59d074f7a568815"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7285480ea891dd0bfa029c96d7021a86194ee52169f9221f6d7f6c9b229bb6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50fd7513d1a1483fee5ac6b0fe12110a23484b3f414ccc2207f011b63812fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849e5bbfcb5e6352d09b915aef4de8653600001bb948109455952364f91b3034"
    sha256 cellar: :any_skip_relocation, sonoma:        "270550e19deffe737a205debbc62f0a6f615021c01af3383a605aa95fc3e6e8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df9b2efbaaed173d1a96fc923b2f30f0b78ff61f076951924e12d58706e5efc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971fe93c72f7c445b5c625b461ce5d4362910787f13674d814b138a614f8f00f"
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
