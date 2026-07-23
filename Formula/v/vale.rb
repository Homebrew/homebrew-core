class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.15.2.tar.gz"
  sha256 "5774342156ff060ba8007b71d8f63f98daa9313ecfadea17aca34b272b16ff1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "170036f757ad3b515f8505ed75a685f1f2286bc3b2164d87a11a05553da67fe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3fc970b89b511cdfeede62d98664ad0e63dcb86e2abd022ec1044ad800d7f68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfb213b08c7df010a8dc92e3319ce02602ba2bdd7c3144baf688db6ce4535dec"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f59bb60a14e097e9d37f5a0bf6d27fd12311404c6c8b002d663d5eb9db0c9ba"
    sha256 cellar: :any,                 arm64_linux:   "9fa47cd30f2498f540347144d9302ca3ce12160a7f4e5b384b7e176c44e85586"
    sha256 cellar: :any,                 x86_64_linux:  "9cc4ee6b7d3765e9580be22db09652d9874c0b5dee271830067d2aacf40262a1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
