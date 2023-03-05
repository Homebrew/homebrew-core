class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.24.0.tar.gz"
  sha256 "42e5744a4cf1a9c79392e2c124ba1c97b1dc27d8b547cbabe71d6151ccfb99a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c7031410c66a3ff0ef14303303100a3005001263f83df59a631d923e5d89f7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c7031410c66a3ff0ef14303303100a3005001263f83df59a631d923e5d89f7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c7031410c66a3ff0ef14303303100a3005001263f83df59a631d923e5d89f7d"
    sha256 cellar: :any_skip_relocation, ventura:        "3d918a277145bb6cb6c2a1d41b0cb44624cff247441dec0be05f2240fe1cbf8c"
    sha256 cellar: :any_skip_relocation, monterey:       "3d918a277145bb6cb6c2a1d41b0cb44624cff247441dec0be05f2240fe1cbf8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d918a277145bb6cb6c2a1d41b0cb44624cff247441dec0be05f2240fe1cbf8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9df2fae76466a7a56a5b31dfaeb10a6ff62be031bab36ff8827f36662657f34"
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
