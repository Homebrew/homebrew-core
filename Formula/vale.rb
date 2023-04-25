class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.24.4.tar.gz"
  sha256 "3363aca630175e06f6490327ac28d10104a320b2360b49d5221779df0df84500"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df7a7da096ac0953a211f02e52af704030f764464eb63d044835f419886dafa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df7a7da096ac0953a211f02e52af704030f764464eb63d044835f419886dafa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df7a7da096ac0953a211f02e52af704030f764464eb63d044835f419886dafa1"
    sha256 cellar: :any_skip_relocation, ventura:        "c3b66a7f6054db2bd0eaef01ab677fa8ec70d0eabf4c4bbd22c74779e36881fe"
    sha256 cellar: :any_skip_relocation, monterey:       "c3b66a7f6054db2bd0eaef01ab677fa8ec70d0eabf4c4bbd22c74779e36881fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3b66a7f6054db2bd0eaef01ab677fa8ec70d0eabf4c4bbd22c74779e36881fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cc68b247cf9f91d8fa5d03415628b32b93c7f9d0e97fa30df61e6043b55b307"
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
