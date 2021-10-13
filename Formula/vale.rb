class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.11.1.tar.gz"
  sha256 "c903fb5bb9c3163372ab697145517187734e5aea693994a36001f2265d645aed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8407524c571e620e585fb94d974ab5377b7fb24c52fa8391e73636acb43468fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ce9a16005975ed0dbce06c25fada476124a9073bd929a1610fd326c2713777a"
    sha256 cellar: :any_skip_relocation, catalina:      "344cf5208f05944feef861b20368b2c20e8d3adc730e71d839833d8d1a066990"
    sha256 cellar: :any_skip_relocation, mojave:        "895af5a48cc7728e62993ffa647cc48ef5fd6ea8cc0316de0fa4f059474f5262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63df6a86eebdda004792b0c526b2e698894cff61c012af0db513eedb27ee58d4"
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
