class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.83.tar.gz"
  sha256 "b2fe1cc9b921a06d036f7b9849185c0431ab21962ae66352ba6d70c229ddf35c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7625ae196a9eabb80f81c48fef0c51323c2d6d8f25aecf7f984c47ec6b298cee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d27eb68d044b82a9d492d63e5127d3b732c61b31263d63412d07d9ffb93176f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6296bc3ec350a196b424f65e2d997ba2e73d27f4754a7c150cb04e05fbab2a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e69d4f06273eafe8090dac5212c20ee3b3676e90910b7927ca2878baecee76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "845c0b5bb0cf26844b6979489e6b8985affb8ad6f3cdd876eb2230969affa448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3daec21e7f7b1534cf14d2b8866d837023f84c7a7bca5290aedf2ad2ab4742"
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
