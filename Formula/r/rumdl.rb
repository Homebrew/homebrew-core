class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.68.tar.gz"
  sha256 "f9ccab8e405fac0110bf1c9b90ed61fa14cee5122f51f7d5b6c6f8a2b1e821e8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47daeec3671af215f866e15e9985541dba9479cd521cf12480c2c83efb497591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19bd2aec50c3f3b85ee6dda7203a15bbcb35fddcf7ff8ad31f9c03596794e4a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ad4b0520eba283ac4e904899c07b3d85ff014948450af09f8f4c0a22196e14"
    sha256 cellar: :any_skip_relocation, sonoma:        "0656cd75608bfd7b9567daabd2bef1f143f41dfd77e74b0ad1dfe4e23bb28063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "750bde46d6a92286c89fa0ac21c1a112cc446e41b46c41d311551797f9839fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd087cc82d87399d84c7bc85c26cb388465336c6c4c3ff8adadd7e0fd677733"
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
