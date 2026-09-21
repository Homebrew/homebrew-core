class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.75.tar.gz"
  sha256 "5ded5e8da2c2c004c7748c13da381afc2f6eb62167525724f578a49d7c515634"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31aaad312058ea9b7a36cf943d5edd45a3216779e980dc2fcd0ad8b0e67b247b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "028ea9c78370f2cf0b31219551ab425ea86fd8ab415f8c803fdbfe19b4b40568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "491d2fd8cbc388d0ee5f20361924b3bbb4674df783af7e4de0f64ed24f843af2"
    sha256 cellar: :any,                 arm64_linux:       "fe8595acfc9cfc58718ba682be36efa11b15fac178db72f9157901cdb2f77f23"
    sha256 cellar: :any,                 x86_64_linux:      "20ed796804cf96f61ce13eb58687d61a6567ef7213e54138e4d5e23244584de6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
