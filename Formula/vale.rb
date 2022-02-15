class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.15.1.tar.gz"
  sha256 "2bbae984b4fc612a1d49c10b31d08899554c3410c74b5c28691ce0ac3d1a9e7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a6849cc64b8afd990723822179d9018439d66a921dec75ee09942257b640c8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53fba5f6f4b295f9817821000738bd44497a042b8c15ed9da2e019a1c7fc9c9a"
    sha256 cellar: :any_skip_relocation, monterey:       "442a79302eb5b10583db5f7b47df2a7c04a821b95338c309f378afdbcc436bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "344e8d3edc5d1ca955a2310eeea19b78d8449bc87e49d5ac24e67710c94e2b8a"
    sha256 cellar: :any_skip_relocation, catalina:       "e4c6186942b68c01633b8c9b27a27407048670c4580c117f32b2d29e041a9563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e58bdf8878c25ffcab05790b88969223d24158ebbca6830f4bd04908cc4b1585"
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
