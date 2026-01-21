class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "2bb33fe834ad2da7fed2e1fd1f17a92f0c48df7bf238c56ba9306de5cd20e086"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6052f82d33b51e6a7e69a1deb9298364077f6c9ca1df6a5846290cea67cdfc08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "014c3e20a25a14f3d3311eb4f93680df9826cf5a8375b859c7ffa9a248d7e2fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4fb79055c431b7def4952c56daafe37d08d10424dc7a7fde2cf40fe08d2f14a"
    sha256 cellar: :any_skip_relocation, sonoma:        "95489d47b768084316c8f222edafec8bcc1df8c3533b0d319a6eb40ebc1a3479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98816f71e20898c820b7bc8e565b6f83d0ba0b4db5d53b0c84d6e2e63e9a9020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565ff7359d1ce5f0205392b92fa8d170318f8ad78ec3c4d5e05ddb01edc0226b"
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
