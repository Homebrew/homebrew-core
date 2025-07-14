class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "26b4c02024c441929e7fd2d79a9b1f94489f85d2e87cd25f9efa2057d10a65f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52c72c6d6dfb98c1cd8a120a3a0f229d5b19a0b79d8ba47cd2e27fa13d54ec0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c3a84dc7b4761fe9dd0416ac90e87d64b992c2353056febaccf1cf98376757"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88f1e7d188560eaaa939ce5efaa03c4a60667235de1e8d4fb573e0cd746ae5a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "690ad8b9bdda9aacf2cfa19a84a48770c4f2288450a25a978eefdd3e96d228f4"
    sha256 cellar: :any_skip_relocation, ventura:       "e1425665f90b9d5d93282a817b2e9770faefb60812314c0b86acda344a1cd54c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0d2668245f7855ab35c8addcf09dbbe3a96875ee109fccfa60e1b3dfd468e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b3a90d67c4001f2f580b60d74f94d19c3c2a942933d8a522bb0ccc9874171cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
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
