class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "1d76de6d263273abdbe44d601c7e1ffb4ff9e52d90694f0e23ec1c6fd3e2a3e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ef6c1811d861ddd9d961c4136c3e1bf49a4f4694873e19d7d87b1b73cc85a53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf44e705ab888d04f7550b7df1833f41636ed69dcde0bad44588193fd1c6a42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aac1cdaed7cc8a14b3e7104b9aa4b1a95d613957ff63d3e1ced51af76487c08"
    sha256 cellar: :any_skip_relocation, sonoma:        "81b7fc8c2c70761a0a42a8904cbb7cb37b5f1f61cc25913092aae72d18c0c91a"
    sha256 cellar: :any,                 arm64_linux:   "e7191a53cc2493128446c495106f05b16a6a106ea1342e18e460399140127f8a"
    sha256 cellar: :any,                 x86_64_linux:  "41c55f638d072880b2b2649548271863f723aa6d2de20eecb7c893ab079c2bd4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~YAML
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    YAML

    (testpath/"vale.ini").write <<~INI
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    INI

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
