class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.15.3.tar.gz"
  sha256 "767c3c271b733e76c84e5e5340eb25d05fa06606bdbbb7f4eb94a224d9fceb6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24c087b576b5990d05fea929771b1807c3979b7e8caf1598acaaa3f82c2342c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586dc39e8babd6672938350e71c4030452b30b98aeb1bd1ee437f03c473942c7"
    sha256 cellar: :any_skip_relocation, monterey:       "0a7ac6667e141fe3b5561c4e26476c6a20aad4e59cc5694aa504cc6eea4139d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4253fdafdb4684a93d1c48f4c369b5cb14f8c100f0b6663666f65c28a947183f"
    sha256 cellar: :any_skip_relocation, catalina:       "cc56f6b236994e37e4cafdfc873ca0d1309232688e02331ee22848cf8ceac5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea99d4a9a0bedf3d4e9b6fe695f552ae7328562b06df321583ee7ea0980e3430"
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
