class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "e5527003b31367153df78f16fa466b32afb0e07501f5183bcd56dce1a263fdcb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d3db0fa41f9e13ff73f0b732da82e09a67ea12f587c84acc5ab2b9d7a6fca4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7a849275ab2a3d9521b5e81937c8a03f358cb4af93caadaa918642c8514bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ea3bb7cf0d402fa85359b9d35a8fc8e27dfa84ce9632b16c6dc150426653e8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "14f32ca90fb9c9ec25ac0618a0f763f8277b3ed14bc6bc7fc3d327f4a156d4f3"
    sha256 cellar: :any,                 arm64_linux:   "4cde8d73a27f8112eadb0816e51cae99ef5186910d96b3cb8cf18a6ae9eb3dcc"
    sha256 cellar: :any,                 x86_64_linux:  "92d8a2388276dcb403cd30fde7aebd2a4de8a2b2e06b9bcd93a8df788374faf8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
