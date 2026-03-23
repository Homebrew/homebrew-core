class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.58.tar.gz"
  sha256 "545ba08175ec312e36586dc5a1ffdf37d397b32147177d9dfe1619d4278e1551"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89a96708a9792f519f5ff14bb6720cb732477af61cc8a3752f4c558c23628146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a4a98bebc6be78a4393675ed486c38a24c661fbf85d1a0446c35fe7838b345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "706c9c4d2f1f463a4f5f934c873b7a9def27204d8fe4fba89d48b0a4d63d4696"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e7a545b72091787f90d30ce64790862d3a51ccdaeacba3445461ddb3ce67306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f371213a013d1fd22a7472c151ffce6307c5d301f7b645da612f2bf29ac40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc7efb6bfb886a635c50d33c47b97df50199c82bf9148a0412c57979ad5244d"
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
