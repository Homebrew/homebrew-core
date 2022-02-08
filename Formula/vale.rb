class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.15.0.tar.gz"
  sha256 "a37cf048ddf17a30adcceefcc743133961cd7a7deaf4c1c44e96de523b95b6a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db1913dbe0ba636dd6e19e2bfda3bdd745bd50b829aa0e4c24587ada0301e35c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40526e283b37a83d6ef646a6dfb4a7a09a30eaac67826c673d5e2f33574a57ee"
    sha256 cellar: :any_skip_relocation, monterey:       "1b40d5d8503c33e5347e27d13c4fe21c7e4269677d256b7c4def3ab0b8901371"
    sha256 cellar: :any_skip_relocation, big_sur:        "483b310345deb1b5405075f49804d231bfd8e701f4eff816051943e903fc0ea6"
    sha256 cellar: :any_skip_relocation, catalina:       "72f2d65c70e62569954ff4987725bc2fa4a8b65cd8e471f98fd7e5f69f53c025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0561a0038141cd88c8a3ade0eb8084a3bac056f25dfb6ad034e1ab10056252"
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
