class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.19.0.tar.gz"
  sha256 "bb2e3ffa0901ebc46686ee99ef52ec4c2634dd0c226d591fde4a7d585a44e2c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfd4bdee51e2928ef67c26bba57fe42cf44be231d9274dc6f7ac0c212f421e40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41a78fb4c5c5b399ff1de4ada9dc86b4c49004879259a441af28b9b0f6b137f8"
    sha256 cellar: :any_skip_relocation, monterey:       "35c98f883bcfcb7327ee9743bd26808f260b9e502d790afad429bf94255e709a"
    sha256 cellar: :any_skip_relocation, big_sur:        "39fa089dfdbaf48a8f6683c0772817acefa82a7124ab719ea8db84087a34ec6b"
    sha256 cellar: :any_skip_relocation, catalina:       "b67837617cc6fe4fc3b52895a264090639e0f627ee21de1c578f3ade1866c6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e3ef52f51a54420737f6214cd189f1215290fb03c132dd4cfc54609a86cf8ba"
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
