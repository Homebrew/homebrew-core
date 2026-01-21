class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.222.tar.gz"
  sha256 "b43795489a97c358bc450e1a01b74229c8c1ee68cc9c27a797ffd2e64458d77a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f591e92bd3d712b495e74053787c524f07033ba7231bd2030d2b351b9e9021d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ce96a44205bddb4c3ef479f79efa23db9c2c94384df54cb4379cf7dfccda4e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f930d407ca7530f4ce423e9d8ad90a091347e841669655d6f13d9c5b72182b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "19afdf5f25b7e16cd501d098aceb73d36a08dc4ee97159bb7a87d71803326598"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe44c589b0a5e1390b1ba73f2d4b7da49ae2d234e2326db0b165239245abc1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20df44b376d7180bab4d84640d5cee79dfe2fc5cf7ac6cf657f189e29cb5bf1c"
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
