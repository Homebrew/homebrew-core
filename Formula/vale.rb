class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.9.1.tar.gz"
  sha256 "39457ec92f155a69b21d3e6dda8506517f2ab6a4493683598a16e62dd50eda4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44ce5d217119a6d62792bb5e0b50654f128dce259e95f67680f0a617f3d1c436"
    sha256 cellar: :any_skip_relocation, big_sur:       "2392a04b032d4405ffa4db3abae9f72253d49f8b12a66dcb5c5a960ae5e4fb60"
    sha256 cellar: :any_skip_relocation, catalina:      "7ddfb6f000d0b7f1b2f3ab2fed8ad0809bbe72845eb68d93828b1668057f2841"
    sha256 cellar: :any_skip_relocation, mojave:        "432767548946854640f80fe77fa0fe4751994163d4b32133df0a80a11b447609"
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
