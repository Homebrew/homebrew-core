class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.28.1.tar.gz"
  sha256 "8ccc68482a36a9123c078267ccbaca6e0be678ef2a1991ef935191cbe9bed8cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "240f035bd7477df3ebdab0b27c9e189d329365fcaea17d6430c25119f101556c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "240f035bd7477df3ebdab0b27c9e189d329365fcaea17d6430c25119f101556c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "240f035bd7477df3ebdab0b27c9e189d329365fcaea17d6430c25119f101556c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a00ee2329ee79542f0ab648acc98d7abec519c29b4be63d49c51c463ad211b98"
    sha256 cellar: :any,                 x86_64_linux:      "7306a03731275c2c9bdf51c8a55fdb46d447540525289374458869694786880d"
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
