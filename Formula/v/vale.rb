class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "07dac0e876382afedaed0f5a266a95f0633b80130fc4e1f472885756adf46ed7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6ef62dae26adbef09b18b0763ba196bbd38e3addc7d9c076e9f50e29b477b78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fd0078541ce4e9aa768710b925216ef0047f4b04dea2d22e89a93c3c3d238ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "072e82206d450c675d194fcf90db278824015dd58a7db3599991352ce73e5b17"
    sha256 cellar: :any_skip_relocation, sonoma:         "85fad0c410ea03cbffdee5842ab45e6278374cc3e1080ece48ca15fe2059de7b"
    sha256 cellar: :any_skip_relocation, ventura:        "de64f73a41172c48ebe0113c32f88cd10101240bfe287f067c2e86855c6bd271"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea1293e42542ebd31897f52f4aabc767bf30b6bd6858587265b2482b15ae525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce9d028718ba5186b8fc003a82bd65d7ffb2bafb4fec37a8ed4944ae4d1dbe9"
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
