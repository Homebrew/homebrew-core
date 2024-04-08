class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "03ab170669dfad77dd247d903f65d95584daab4661bb9dc9130e56487fca9617"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c432dc425c3b506428c19df82e8f7fa09b571793dba9e0b5888263dafd398be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac16e67a524480826b82a6ae83c2425a194fd3cc900b4f82039909df3472de63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c535f85b749cd9a23e64f5e5e3cd9fcb4c06107676005e506249a0d730d54b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b733f8ad5e5fc667e4b187cb57c892305cdc068ae6e3628d9ffe3b744b95650b"
    sha256 cellar: :any_skip_relocation, ventura:        "5f57e2345779fd0d3367e3c6c0f2068a94aca371d41d5c656301cc044b96a7d3"
    sha256 cellar: :any_skip_relocation, monterey:       "7630be02dee71720d9b886f20ad02ac3f0bb848c31c190546481235f62c9ac26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f1ca5e78660dcef0632bfc6c67f07b3735d8d45a555121e76a97dc6f8c71f5"
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
