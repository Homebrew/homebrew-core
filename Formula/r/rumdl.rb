class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "a0033a5cceda433fd44de04c4bb2a5790346985f6b5ffa74feed2d3097653801"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "df15372352f5ddb7edaf6476cebe6f0b8aa489c7b2971e2ce792c4e64c5150cf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8ac0c0e695e6f92fcbc4e643da5c55e2628010b541855a18660f59b15745f2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3b790cbb65600a23202531a2185321515788211048d3ff2d409e832721e4b39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2040bbec6ed3fc9af8c7969e4e5cbd31f0d7dbe20636866280d14fb7f82eff31"
    sha256 cellar: :any,                 arm64_linux:       "5e0a7789eb86cafd1dd853307959a18bddfef33b10dd69f65fe0a98a5da7d4a7"
    sha256 cellar: :any,                 x86_64_linux:      "2c21718f5ed516191a48261696ab4ff83a879d2e10c6d14637c109477c1d3075"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
