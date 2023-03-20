class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.24.0.tar.gz"
  sha256 "42e5744a4cf1a9c79392e2c124ba1c97b1dc27d8b547cbabe71d6151ccfb99a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1115ca0d9c6a3cc42a781b151df8b2d0e3fdef8660d5ad3de1401d64c7bf019e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1115ca0d9c6a3cc42a781b151df8b2d0e3fdef8660d5ad3de1401d64c7bf019e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1115ca0d9c6a3cc42a781b151df8b2d0e3fdef8660d5ad3de1401d64c7bf019e"
    sha256 cellar: :any_skip_relocation, ventura:        "a422a0d4852f3513333249b1afd744ec2d3a6bf6f6f9a5b6e4916710777513d0"
    sha256 cellar: :any_skip_relocation, monterey:       "a422a0d4852f3513333249b1afd744ec2d3a6bf6f6f9a5b6e4916710777513d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a422a0d4852f3513333249b1afd744ec2d3a6bf6f6f9a5b6e4916710777513d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64289972861b4a0a4b9843d917d000837e9a66196674fd75d4af6bfb316b9a57"
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
