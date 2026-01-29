class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "6b1833fd08417ab0d1b734f03feca6293c894669a1bea32c1e1812ad1baa3ba2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ebabcc9ba867692245104301bbf756943440171ef713a9e4902f821af7ac3f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e5e510e4f0fa507803608d981e0104b10bf662cd813514e37c4d3a4baa9c0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1421eb99dc543fca619d905d63209c15a0f15f83d1ed99f75fce157884ea3e69"
    sha256 cellar: :any_skip_relocation, sonoma:        "a93ac38ac75e619510f992db662fdfbb44698a9aa18633c3ebac506b86ae9309"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "807d8b00eca65127649b1a9fca4bd221837957cbf8faea81c7ef7dc25b2491b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8825c3a0d36dfa1518845926ae56c234ec952a2dbbf26ba34ed945096e108ea9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
