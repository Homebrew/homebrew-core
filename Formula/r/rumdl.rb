class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "37e66de58ae5c00ac98b746b5bedb1528028dae7ec0a66e5f6cddfd7fdf42375"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf5e513d196a660f1df328ce648ac9b48a56052d8d72ca9e2dd3be9c5d972f57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "355dc57861664cbe34c84b8af9e3923e6199238a83e3b51a9d6f46f792d90963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c961273d1e9a9c2e3b778a228ccc4f38f8e1ce095d7db80b8e4bc894866215"
    sha256 cellar: :any_skip_relocation, sonoma:        "828c577fb4c20ada5d541b303a6679a21a6ae1cf16cc35272122e83fc28a4762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1c8b1b5adcbcdfaaa95c072860f5b2b31b1a259616e0489bf9a898ee7c23f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee00113ab9c2474d647827dce744d937f0ae660be6c9e12b1d3b9c57fbfcce96"
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
