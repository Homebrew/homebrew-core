class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.27.0.tar.gz"
  sha256 "66636c2528aac28c173f9449e3f4f1429b84d5be8d7877bf52fa6c5fd50ce5a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6d61669794291915d614c586f37f880d66c6b6bb08aa57b69c7fe95082c30d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6d61669794291915d614c586f37f880d66c6b6bb08aa57b69c7fe95082c30d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6d61669794291915d614c586f37f880d66c6b6bb08aa57b69c7fe95082c30d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ec521a24142b42036a97b88ce344c6a9c878e5dd880ced12d713e00d209e855"
    sha256 cellar: :any,                 x86_64_linux:      "faf377fd731603c8b341178805cddf78345fee8d5d65f6d849cd83e17145b763"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vale"
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
