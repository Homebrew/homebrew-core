class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.78.tar.gz"
  sha256 "2e44bc3234387aba50222233bc25767e04f95d7a9c9f5708cd2e79fd20a18439"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b52a4ad69e8bf5c3b4be2abcd4218225831d45dbaeab02af6b561bd0004022d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "054cc81c1b4a80bb6f343eb11c9e8e00eb4433cface556b98f3a544333785233"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cd40c158ecd8ab34be05416f9213c3793e38642ec6775fd905ab4b5148035d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a6d4e0d9198ed30db7e284b0cbede751d3e69627ece3c2b1503d400ead72ef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9c1ae785db1f59b4ae0ba9c48be9ac877fee2bb98e515a467871932ba651d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6aa6f593acdfc5ca92ec1c27212799669477ab35b713978cfa8198fafb1c875"
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
