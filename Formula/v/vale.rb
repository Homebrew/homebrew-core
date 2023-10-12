class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.29.3.tar.gz"
  sha256 "660c1494db19bf7a0a692e83a3585c9ae30893c37f38436b012ccd66eaf839fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59fe9f96f8c025df0cf5fd8fc698309dda379a0bb292214f1128ab51a832f9d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bace9fe9cf322568fb6a053c6f6c83114e01ef0a0497ec5695a31a185b04f34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a21452320852874610032afb43f18a89f20de656d55f89484e4230e20846d43b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d440f8f27343be4273aaade12dbef8f8b5d99aa02a27db1fc590e39a09537560"
    sha256 cellar: :any_skip_relocation, ventura:        "783d005aa4a220eb28f1c6c5c61867a50b2e6decd81cbcb37da77aee064141ad"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2c7f533c987c6848c47111d0532f9b5d5422c5d2ce9b6e58a08ffe8c8382fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f4e5ea0e4c8819ce2ceaf1367cc6d5a12264e0ec54a2ec98c0da6c364a32742"
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
