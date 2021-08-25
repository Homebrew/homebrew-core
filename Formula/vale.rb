class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.5.tar.gz"
  sha256 "fe6bf766a392c87bc707fa03c23c3bf7664114b0b8df6a99d2af6673ba7a241d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ad170b47f3d9a002dd1401de3eeb44f573316855ef4921767891c59938658cce"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd3c125add16818ad96b65c96cbe254831606c0f5e38bdceaa67465873a6a254"
    sha256 cellar: :any_skip_relocation, catalina:      "d1ffa2383e00c8a1af85788bc9ac933da0199794a5f688027fb74cfea408af6b"
    sha256 cellar: :any_skip_relocation, mojave:        "d0a402c2ac07d527bb4003a57ead7572dc68b3cf332977dc0d091807667775e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61205767cd32ac368d6982b338aa432902718d16ec334d2d35233c5c01eb7fdf"
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
