class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.11.1.tar.gz"
  sha256 "c903fb5bb9c3163372ab697145517187734e5aea693994a36001f2265d645aed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7cd9e1c4bef298ba5854449a904c9e1bd247a72155b3611d6150b74d43b21b56"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b56e5afa4e48d55c7f5867a7d7ab0b4a17ea5696b25ce9b55ecd31f1e0b9d1d"
    sha256 cellar: :any_skip_relocation, catalina:      "549bafea9e4481555108d2c11ec5e31999ed7ae7c1840a5700357f63f4c1c12b"
    sha256 cellar: :any_skip_relocation, mojave:        "90254ba59c136d05385580bfe7c35f4236984960a0e0fd9a7c90ae5b1ceeea4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9502c55d37b053945d43e8c66297cb32ba4b6407ea5ac59aac25abac8c2584"
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
