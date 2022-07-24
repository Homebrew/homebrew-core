class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.20.1.tar.gz"
  sha256 "48cb6e37579b83fb75b919021c79e92c6b0519998818bf0080b2c7a53cf5f563"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40d44687d314dddf205dfdb5d42526160e22b3003959f118271e9a3cff35d943"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10a9a24accb4fb1619b500f5738d3b8bad0170ee53fd811d1fc74810b2b1ab58"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf118155d40563db559adf3d3a096ec46666cb389eb83c6ef2eeadcb9f54aef"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c1f588851ff663f1c18d53013a2bddf4cab1c8be60e7d6921f7749c145188e1"
    sha256 cellar: :any_skip_relocation, catalina:       "6e376f3ce06675896231af3b7fc0b471a244761f7750d61c97f40bc5e31a5385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f64f6f28be73b1932c5888a2c665c92f2e2cbe125eb8cd3b6ff5cb0654c9d241"
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
