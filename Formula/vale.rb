class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.15.5.tar.gz"
  sha256 "157cdab83eba405da4301b3ed3aa1e5cea085dd32dd212494df2cc31245706da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e79e00faf0d44eedb38133d28e0cfa021cee01c530464539a97ccabf99c6cae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e45face9c59e8124c3a7ccf466c2cb9297a6ae1434d6e9d6e4746bbae82b9771"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5510bc10d3447d5f1c5455e4715e7a15b1f29020f2e736254edc5eccad18cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ece371e4749cfe0ea26551293f9d0e76a5670bd216276f72adc344eae53e8f5"
    sha256 cellar: :any_skip_relocation, catalina:       "d631dbf0a5533c8dce6f618f49cd75b407d5258ba2d8fda67eb04cf2f11dea7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2955e461348409ab99f4082b3a80ff360dabdc75ea3572537d0454d9c1602eb"
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
