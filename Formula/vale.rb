class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.9.0.tar.gz"
  sha256 "73829e7a14fa8e1e876a24ef6a3562d8a2b5215f444b429fe04da17b5c27adc9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "38991b09d79f81a90f2c2999a7ff773d3d84531698568f9c244cf549a7f60d10" => :big_sur
    sha256 "f1628677ea43927d75d83ed8d6e243f14ecfdbe4af43cd867f27f2b95e6f0e30" => :arm64_big_sur
    sha256 "42a756b8a19a2786faa3d551434ca69e9afe64829c84418e2f0e04a6e574c759" => :catalina
    sha256 "14c77c3595a13c57f74df9037f7acfe60b5cc55ada0046060f0d8e01c4a1b1dd" => :mojave
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
