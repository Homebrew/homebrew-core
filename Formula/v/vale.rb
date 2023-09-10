class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.28.3.tar.gz"
  sha256 "93224b7e587268a13698f135850144c2fee85cfda66d629f70678e73b7f75135"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a5910864153f2b53b79ada347fda10b67afcd5978592210e64ebc1ed46b3562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48138a9c22761b1e20092599b91271eccc678f698f0eccf413344fb7a0824635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8b4c4cf0c822610d446004380c7caa502b380ac2a35e1f59f6ebbca992a4165"
    sha256 cellar: :any_skip_relocation, ventura:        "371b39a75cf8c561c9b255d2def6cd7d26b48322b634aa611bbe7961a1615b1a"
    sha256 cellar: :any_skip_relocation, monterey:       "97220585ad53a4bc47bfd9d5f44e4f15ec421cdbffeb6f2ac6d4c6d46d9cbd2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "77eafaa1674da6127a46828d49a7e82ea8093242c38c91c054c841650139f894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5637c952491d9ef8b204fe5268850886616a78222ef9eccd8c5fd2d8d2e612e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/vale"
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
