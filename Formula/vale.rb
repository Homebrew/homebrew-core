class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.20.1.tar.gz"
  sha256 "48cb6e37579b83fb75b919021c79e92c6b0519998818bf0080b2c7a53cf5f563"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6945d621bbda7fb4bffcf093e1f88e438cdc135b7e139a883e8115de18f3ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bd680e73b11ea28c8f189e831d51dc58916b0a06c22e39990eed443b2a983b2"
    sha256 cellar: :any_skip_relocation, monterey:       "d3049e525eeb2e4c56b1aa77b4c794b919584a27a6a59fc24f79191ee49f0727"
    sha256 cellar: :any_skip_relocation, big_sur:        "39969b944c5c616b18d03d35ddc4a824f7ee2fd25974eb91a58af9a7ccbe8b71"
    sha256 cellar: :any_skip_relocation, catalina:       "2778ba29ec8a6f2e96866550b2b6a135984b47cd52f33e551da93acd017e35ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05725596b1dbe72766634f941ad42539013ccb5f1804dc115c9750adba8e64c2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
