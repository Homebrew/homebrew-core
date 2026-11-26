class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.29.0.tar.gz"
  sha256 "68bbb94af847e32bc14725e61cf0b5319521960cce6f70c2a21872e9a903e9aa"
  license "MIT"

  bottle do
    manifest_sha256 "b741552dab84dc6eebe7156cd5b42e670d306812bb5bc6bb1f2889a47b33b2a4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e3b1c1e734db588909b03de7734716ddbcfdfb32a90cd342af6a12f3b536d5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e3b1c1e734db588909b03de7734716ddbcfdfb32a90cd342af6a12f3b536d5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e3b1c1e734db588909b03de7734716ddbcfdfb32a90cd342af6a12f3b536d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e632c4bedf2ea4034eed971d7ba47933bd6207d888573a9dff9e17d2fdb8f25"
    sha256 cellar: :any,                 x86_64_linux:      "61c2d3bc32ac80c2ea87a2e7fae0dae38f14fd28d60a07e27a6b2c66d4cc965c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~YAML
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    YAML

    (testpath/"vale.ini").write <<~INI
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    INI

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
