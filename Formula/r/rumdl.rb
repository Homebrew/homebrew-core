class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.65.tar.gz"
  sha256 "8c3fdbafbdcc6fde28a0507a0a9f29f42ebf9d26f8427729906c34d895b13036"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe719acbe3e730c7f19e44f3a57d0622b699d75784ca0f4db0e1343f80a60ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8598312859da60cc0a1852e22a27a013c1db92fb585b6e41aca1216d5c75dc2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "268de594b493d5c962fde89515f5d294d02da1483146e22b03aa089e7f6e5ca1"
    sha256 cellar: :any,                 arm64_linux:   "3e0e3a09fd608566186c5a111f6f96be6336078a9eecba53e8005de87e0852b2"
    sha256 cellar: :any,                 x86_64_linux:  "1c9b4391784bf4d67da7c8ca266e79ac1289c6b1724d4eebe241e06108818b3e"
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
