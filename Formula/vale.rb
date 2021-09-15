class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.6.tar.gz"
  sha256 "58d1d15dcee89b8401057eca8808b2892dd11855eacd717aa5fc0eac39936a32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "699f7d5d6ec74bf954f6dd55007ab18a32bf508123ff53c279cf6688a768f300"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d2537c578e7233306b4f4eae171d8190386d69b92973d924cca7eb1b0541102"
    sha256 cellar: :any_skip_relocation, catalina:      "d463f85bd76b08c3b2e07a9789d463b84171e9b11f391b76499d99637e8f180a"
    sha256 cellar: :any_skip_relocation, mojave:        "9f58f3413f874cd4e6c034e66f394581b9b6fb4a7d9fc30ce02cb1ce47b3bade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9d9e7ebcf2b6b54434ebd89becbdd7b658191a5eb33a751cef3518c38417e2"
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
