class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.14.2.tar.gz"
  sha256 "7141b3602568cc000b191661a7866bdbd0192123df79e6f0faaab21eebe98071"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7a7a6e477944d5105346e8c8c45bf4ca87b65efd7dae5567d10936b0f59e15b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d02c37de960c050f190f470e0ee0f7f4bbae94ab1e61f27afdfb29c2bcd10731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21ca221fc848aec0c12951cf55e75c70f3ce067bd003175a299ec0f105ccd472"
    sha256 cellar: :any_skip_relocation, sonoma:        "bea63409ae93b9555840f0f075e0cdf761361d747540d2f789eb73ab56564df5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f249ab213dc746ba005a124c9c4b664f650018a7de3e6d337423dba892c188e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a241e0dac5c487867d87b5a806348295bab57e0f99e97f26f1cd88b03dd2a92d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
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
