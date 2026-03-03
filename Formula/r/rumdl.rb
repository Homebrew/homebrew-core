class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "15e92e341a3c5dbffb402b5bcfb8f38afeeb5d45e9109c99c0628cee5d89723c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d749d64d512735a940dbb3dcf7bc76bbf87937900bef311a9ec4eba74b58d75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d9ecf5672039d304ef8bbf0b67e66182162bbf3415fc253c34d194a23befb72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c44b74045e4b6d6110a2b376cc6373a6ec2a34042703f99da261454f40bf76e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab425ce66661f2b18caf2b2bf63c1e3583d175615a6602b323d96966dc139d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "144a220a87ac34c2e6ae2ab8c6b7c0349b339f7f95ae63c19d578598c46cb235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23cb8ac6f5e92e09698a1372f56a43686e06e0d2c625abf5c7402be7f96aa4c"
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
