class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.71.tar.gz"
  sha256 "c334ac92f2632352610be843838c182229acb36bf92f90e6fba5b33b134de6cd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e76b4b06a8b2e2e2c11fb61446f83ceaa737b7c6505e4ac60a8ac54a390e8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0ecc9a73dd990b1c93fa87291fe7457ae9d5400e00fe236fb2aa8328abdd26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013ce1b236ce93f1a54fe8dd99276e49a15f6fa806b381684c3164ced10be28b"
    sha256 cellar: :any_skip_relocation, sonoma:        "08f4ddc89a32a3c12eea135b1fcbd386157cd5fe947f3bf738eb0d45dc41de1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c21cb36af3f10b53aeb6d49021e8311331a19e27991c5cc45574917391a32fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e18e15ab21ad0082b9a5361a157d6fdea35df7847eed6cbbea934ad3dd14a35"
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
