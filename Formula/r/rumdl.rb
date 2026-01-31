class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "3c37d4e2499cfa4adedb66b3d62f7f8369ec08dc3d572e044d0113108c8fd909"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5ee70c5a08bc6d83e612668252b6a3906655f29ee2c99bc6d6d7ac6cb652f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcd7ac8a5ac77a13afc0deb619cd9a407ac1002cc1485454af9ee70f4465ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a333c22c3385bdae6a4ae50e2475e3929f67a057286584d2bd8f5c7ef3b612af"
    sha256 cellar: :any_skip_relocation, sonoma:        "e653474dbd0f7437823407abe7f962bf548360df74da0cfdc669fe66ae74b325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e780439d45313dd1496f3f8932138246051a0e77c246d7dd6e4d2084f034f2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6b66ebb2ac533ae167912731dae9acca61ba96e0918b524d280fdc335df0f1"
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
