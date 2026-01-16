class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.218.tar.gz"
  sha256 "a3bd9cdbcea2b75937ff219eecc8e64d93921319bcf37584d4e9642eefefd06a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b71f5cf4beefd67e971850f6cc803b9ab3fdb79dd70ffd8c1deb12c9e074b56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1205b73611c0eff218270800b9bbff370afe6394cb97085584742a4ddf54819e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "889c4c5491fadb29ac21d027663816cad17dd1b2dceddd7e952b44f1ae676324"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2ed0c75960117d143fe2a405dfd36616d9871f84c262b329dde28d553bfce73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f33ddfafef54e36e8ea49ed44b3d2e366652651b83ebd9b18f20433a4cf3e0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eab0290436ac7cee83ee9a7626b44a1aac641bee3801edd7a5da6c69baee8d3"
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
