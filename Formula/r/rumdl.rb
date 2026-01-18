class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.220.tar.gz"
  sha256 "1add57fe8a8f260fbecd971ce687a7f5d0e9b3600b39a8d7bf595f0176c6ffb0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32c6f34f83437e29e86bd7a4374414f96be6d21256d5cc0bde9e25bff6c9afcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc345f0c79c31ba92f40f1e4a9bed8165fa3919f2ae50dc253c533984033c089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79e15e412b769ccd847a4d69c25d51b6aa0b5875f3c2b401924305c85c066aa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "389e33f9333469f7b032076ea5cbd49da0293dfe92912466deb6ff1866cae968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1433ec89466e589685e0ed8105e2101e2deb70b7c977b590aa8b1c65d30544c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d95bdffcd5c25edc3fef3cbe04521f480f59e82b88d89aebde6e8d22bc6f7b20"
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
