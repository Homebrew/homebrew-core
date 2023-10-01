class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.29.0.tar.gz"
  sha256 "d94bb530ff4282f22adb9168dc619c4387e23902cbf88052772fb5cd8fdb3e64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4181faefecc789688a3187ce684433901adcf0b30e267458198bb38973604cd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72fb8aea0c537c8f78957d54b7f727efddd6698536c36c6e5282d0fff9aec279"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "382ffef3069f78683d87a7a217d5fe90dac068c6c6a999e1d8c2c915deae238a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a6b661152036d25385caa2fac9992feb2c06ef7ce6c9b7456d5248e7f78a473"
    sha256 cellar: :any_skip_relocation, sonoma:         "82f1e4aecfce91b5282e939e8bd06402a12d6924a999eb3af12c57db8bf1e879"
    sha256 cellar: :any_skip_relocation, ventura:        "8bbbcd75f2a52736f330eba75653be8ca9c5b2b89bff6be53f7427654a7829a5"
    sha256 cellar: :any_skip_relocation, monterey:       "bce36e1ddaa5e6d02800e2214e5042c715fd44f3c60eea0e375a1dc8ea57b82e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b38b9d47b3e371abf92587c2fd086325f469125abad6ef91c5d68ee9826f48dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cf544be28e1b16c3ba403ca4e234611b17fe9bb1ed6b598389f7475b8446a8"
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
