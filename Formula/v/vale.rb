class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "06774ef953064b3e5f5d8e121bf1626eabf8c9ec3cc2def5ef8085a9c3797c89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31405a93ad7979f4c88f1f449f7dfc184ba0b83b02ceab872c71fa6e307e9dd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b025d1b65a68ba8ec2138dd3c27c6591946606578e88f4b70cee9457ac5002c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1469fd3bf08e9d34ea727fc92ccc678ba8e0a0221ef3c771aef092ad904cd6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "436db368cd07f94ee80aff01e2fa21a57d36cd777d9c6f98e5f10324ccb765fa"
    sha256 cellar: :any_skip_relocation, ventura:        "c0d9bb976fc2e2e9ceb5e36bf3fb2859db0be54e923f64e4bca36799cc741b38"
    sha256 cellar: :any_skip_relocation, monterey:       "6922ee1dce4f532bfd3947e3f8de539211d114c0e1cdaaab4f1d9a7db48db885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30c5cfbe7a4e92e08bc7822fd919e952e3140cd4dece5aebc1397108459831af"
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
