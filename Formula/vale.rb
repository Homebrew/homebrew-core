class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.7.tar.gz"
  sha256 "bd045f5d35158b3cb5b2c30db712a0a2263f6bd395ff9e135876487a1d2a9362"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3e1834643e83d84ac6a2fd152a300362325935d3d8398371a62b9f4a8b73322"
    sha256 cellar: :any_skip_relocation, big_sur:       "84531d1d7ed23602e8bd60955333d654f9749e1f082fda406b0b87819070d775"
    sha256 cellar: :any_skip_relocation, catalina:      "1598fd140137c84be4edca6ca777efd1cd2e1e6730266331fef0083abd9a3c17"
    sha256 cellar: :any_skip_relocation, mojave:        "5c6031ddcfefd06df3cf84a3ab7587e1a23ff186e45d76cbf057093b7f134c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6e1c54115f43ee8f22e1eb3c91c35be9813e79d8037dd03f23cda28f9dd7993"
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
