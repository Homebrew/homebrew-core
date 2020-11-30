class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.4.tar.gz"
  sha256 "f68e8340c4ad40abfb3d9bfb0421c675fd4e2f07d57fe01834d7a80db55c08b3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "27cb56a29891b78fbd78aab8e145b63fe8e57034940e0740dc092207c88d7de2" => :big_sur
    sha256 "1199a9c0b47cf85c224ca23de48b393f55f9448270dbeda67701795c4d408e7e" => :catalina
    sha256 "dfdcbdbc0fb02059476fe0b96f7462cd85c3fde3fcd329105c729ca44e4abf23" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}"
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
