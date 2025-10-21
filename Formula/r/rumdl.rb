class Rumdl < Formula
  desc "Fast Markdown linter and formatter"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.164.tar.gz"
  sha256 "045c05237203301dcdf0c3e7b565346fbddd6c888e7f04f8de5f424d9fe0c905"
  license "MIT"
  head "https://github.com/rvben/rumdl.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test version output
    assert_match "rumdl #{version}", shell_output("#{bin}/rumdl --version")

    # Test that rumdl successfully checks valid markdown (exit code 0)
    (testpath/"valid.md").write <<~EOS
      # Valid Heading

      This is valid markdown with proper spacing.

      - List item 1
      - List item 2
    EOS

    output = shell_output("#{bin}/rumdl check #{testpath}/valid.md")
    assert_match "No issues found", output

    # Test that rumdl detects issues in invalid markdown (exit code 1)
    (testpath/"invalid.md").write <<~EOS
      # Bad Heading
      Missing blank line below heading
    EOS

    output = shell_output("#{bin}/rumdl check #{testpath}/invalid.md 2>&1", 1)
    assert_match "MD022", output
    assert_match "Expected 1 blank line below heading", output
  end
end
