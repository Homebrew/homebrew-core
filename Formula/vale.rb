class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.18.0.tar.gz"
  sha256 "5b1b5a3c61ee8d0a3a7aab6df8086721f17e69957ab7e5230f6402326b7cd088"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485acfa04ebc6631384c0ef2808a8ba835e05df2b9ffb25bffa1df973b6fe281"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "642cbb7cf98e7d5090ebe3c511a0062f902c19a6a4bc3a224b5e97e5f2695a50"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef960754bf56288b8fa60b6195a295be161823a7c7971cd5ba7ecd2e3b27269"
    sha256 cellar: :any_skip_relocation, big_sur:        "0526c7c059a23080308e17b705c92420ce3e9853f4c7de3782796b9bc6a81066"
    sha256 cellar: :any_skip_relocation, catalina:       "5da2a9a9965e6db9547ab1bcc246dd0018b2986d0b99f351cff1c35968c445aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49c67f48c25596cd234fe97d16b654d58de1664caefc0ec499356c3b742459a1"
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
