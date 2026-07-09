class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.29.tar.gz"
  sha256 "7bfc619881bd60426a55e36d9e93425603f0bce3a1081f12e93614ca7d6d6b4c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aed5c84fcca934f8cd23f5d5f4b9a3c27405a3c7141f875746a76c6bfaa92937"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ade9be5ad7795c418d9800f9a770ac0cd5e3e5c24d952f218e042424b7de3f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8210f91ff849d50346ba7567f0ec08386e2e3610afd2522fff64301685897c25"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecca132f81e20d61eb78c0e42199a69caf8cd0dec851f8a169010ac42acf67c5"
    sha256 cellar: :any,                 arm64_linux:   "4255207eebb8fbb3081a92a98dc2955b4ee26c32732524825a5370c4842e1dc5"
    sha256 cellar: :any,                 x86_64_linux:  "fff718107fdcfdaabd8605936b5c3e68bf9182e4ba17d5587a412ff5642eb72d"
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
