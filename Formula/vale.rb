class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.14.0.tar.gz"
  sha256 "807c971f3daed704a5a186f39d58c8acee14b5492ea255a5522231661843dba7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a6cba30017938b7549e6ed6870fcda8faf13148b38951de711ff648936e817c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a00cdddec3a5295097ad75bb24437563b321e36a4c4e6aafaf80556f1cf4e5ea"
    sha256 cellar: :any_skip_relocation, monterey:       "59fccfe734b1b435d3f3d3ed740d46ff8d07a7cc9f7b87f30f31b619b0717229"
    sha256 cellar: :any_skip_relocation, big_sur:        "2efe492b854bca8d4275f2246e46916c320b1ba6a1c187b26a68ff6b077e11f4"
    sha256 cellar: :any_skip_relocation, catalina:       "892cd42ec0ce4f0ce805adce459425ca8924d7fbe27a635b45ce3064a2538d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b3d53826565cab0a5fc8cc52eaaaace27018c550c333fd90d1017a6e47ba1e6"
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
