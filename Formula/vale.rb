class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.24.3.tar.gz"
  sha256 "6ece32f70263e03b4b78ab0fb4564be009533c40d4e1db8d0580ab062491c28f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b6e513ee466c3b9872478184a82cc376f71bb8d3bf6ccdbbe5570216658d07b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6e513ee466c3b9872478184a82cc376f71bb8d3bf6ccdbbe5570216658d07b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b6e513ee466c3b9872478184a82cc376f71bb8d3bf6ccdbbe5570216658d07b"
    sha256 cellar: :any_skip_relocation, ventura:        "046a8c224d47afcb92404babab34b3325efa66e8c23732277f336051ab655645"
    sha256 cellar: :any_skip_relocation, monterey:       "046a8c224d47afcb92404babab34b3325efa66e8c23732277f336051ab655645"
    sha256 cellar: :any_skip_relocation, big_sur:        "046a8c224d47afcb92404babab34b3325efa66e8c23732277f336051ab655645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31050fd5933bf42e25275f2581f3f34cd282343187ae75a78a8b9dd2c484c0b7"
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
