class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.18.0.tar.gz"
  sha256 "5b1b5a3c61ee8d0a3a7aab6df8086721f17e69957ab7e5230f6402326b7cd088"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18225d61fca76e290acf5a0d6207bfadd71cc8274ec623ba553fb2c264d8386c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2878e761f26a434e707bf793987aa25c7f07432ef989f7a06b2130b1843b6c8"
    sha256 cellar: :any_skip_relocation, monterey:       "393114a918a0b9bba878f0144bcac7fca2c622806fc4d7c3960cb5135956a569"
    sha256 cellar: :any_skip_relocation, big_sur:        "372960ff42659784a86e55ff3486484151c201e3ece4008459918f26799ac1a0"
    sha256 cellar: :any_skip_relocation, catalina:       "2782c200a5e51d7a02424e59540b9cd15db812b377ac97c7a6ef41f21022f24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b18ad169ff4d65c1ce7345acd696d8f3deffa0fdf378aa72f7624957a0cc57d"
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
