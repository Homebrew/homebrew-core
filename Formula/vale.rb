class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.20.2.tar.gz"
  sha256 "2af425c2a4b1a5ef38303b93276a8d0af94b9b16408721c90f7c7f3b949e6ad5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "163d127945df35524d5a39bf174178979e01535f716a86df4b1522849eefdce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2384e5de6ae05576d69ce26b8e18068efc8b1a53ebd907a122ffce07f9c59e2b"
    sha256 cellar: :any_skip_relocation, monterey:       "e5d15a8bbe627f737664d2765712a1bf81c1d26c2a860dc64bbd5dd557ee2c88"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fe7a880822063535d8fa5033fba65c27491d373c371a422d9ce4ea72b635cce"
    sha256 cellar: :any_skip_relocation, catalina:       "885fc1efd88c9ef46b5bb1226d894e914dc578639361112bec4ec66c32178e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d97b0e59be2cee11de3dc12733c142f8f5b40a8e01750380a2cfc4fad0df404"
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
