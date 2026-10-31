class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "c63c9c9b415d55616c112c04ddd98fba5e94bec0e266bc576e36da6aa7d6b53e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "929cf527cd8a5d5a80036d358f3fa1d5b958915eb1a321b8ae84f25adbf8e1c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "650366d426683e935ba4dab3c1300a8cc30280c692d83c47c50eba8c242ea6a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7330548e4842df47604ef39853048e51aa7fc982d317cbc5fed2aae9a79e5e79"
    sha256 cellar: :any,                 arm64_linux:       "698f61ce6f6538fab0dba766ff8b28d046be30d2bb099a632655cf80e33aa232"
    sha256 cellar: :any,                 x86_64_linux:      "c03f4cce9cc56916c1f47e8df4ca69b9de5bac77e6afa43ebb0f778310b09c53"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
