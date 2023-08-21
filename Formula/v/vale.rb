class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.28.2.tar.gz"
  sha256 "642bd739da11273fc12db8660847899557cfc146e8e4d3a0de7e5d345fe173ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fec09c18bcafe91fcfc10650d917157d299899930781512ef771167e0af6168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d0acaf5029ce9a0131ff1e8daa8e7dfd960e7c74e90cfd433bb5be7267cf29c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95f27d67efbb0674f1ffb7e7999ef2b2bf33a3a8052750f7af31bbe62a081332"
    sha256 cellar: :any_skip_relocation, ventura:        "6b7d44de4fbd05ac642fd2c22b28753b9dfd420d00d86d3c1e25bb1ac7fee47d"
    sha256 cellar: :any_skip_relocation, monterey:       "d0814ef1b855c38c09233fb3388b1a46b73e3ca0d96e84c87a7020207736e7e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "098e72cccb9f92b76c8693437be66a2458ccb3ba2b699144d31d5dedb21ce5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a9f489c1359b8324b1ce2eea8c95f12e0b0a63cb8421022aa45b0138f79edb"
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
