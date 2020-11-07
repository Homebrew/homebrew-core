class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.1.tar.gz"
  sha256 "b264194b11fa6c93c8bf05ba168b4e964ea7bb035caf7b1531c90da21ed7a829"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "20fc18d4ed90e76ad8c5d3c7c681a9ae2dc14f584901628b25d30faa027655e7" => :catalina
    sha256 "c27b0b54f6f1bc2563c76a2b58c3369a6b5dc8de5350f4cf1bf08694e73e44dc" => :mojave
    sha256 "bd28283c640fd8e1ab5eb84dd6086bd1a6bd316f78b6dedd29f78b2720c79bc8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}"
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
