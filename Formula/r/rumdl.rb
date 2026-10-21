class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7b6d9020870823122132755a34b113c6a11d2468c6c3b12fe97f705f45915a3c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "192b73e04cc39713fd3a51771bdaa42029f3fbe877a906682f0bd2e17a48a34a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "337ea5a077de3cf041e9d2523f69b1b95fe369b4bf2ecdb4d5a84e599a151806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ea767b104016234d80b7c73c0a65ac77d79b44218041b62175f0818dbfdf662"
    sha256 cellar: :any,                 arm64_linux:       "7637a443127698b547d6685dd22d3f7c7f6079887cbc8859aff6064d26bc6b61"
    sha256 cellar: :any,                 x86_64_linux:      "5654ff4d64ad63e7300259a10ac719a3099365eae243461ce096fcba0c430048"
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
