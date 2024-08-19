class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "2fba0d956a6442328595a8b3940ee7ad821057e39a68627fd720fb3d67086503"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5a5173a5fa8d9108baa4162042484db00816a37085403ca5e2a572a58d108e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e01859f2180098f5bf547c75033fbaf84b23b0d0a80740ef8f666bfdd90c82b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d701caece218963e7e00520999de7ad803c9750fae03827c7afcf05409a5873"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f04b2c1726938053d83a43b923f5e6f4d9edc12de7a50210f024392549eda90"
    sha256 cellar: :any_skip_relocation, ventura:        "bb3c7cfa09ee9ca83ab7fa169d44f2f6e22cf642a6cd8cd21ff5258bfc97da6c"
    sha256 cellar: :any_skip_relocation, monterey:       "f676234b97bcc43a38d3e295084f8e28a45faa66daa6599585d8d3ffdc8b39c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce955d6c858c46f56c60e01dc907b0546b2417c7790eb7b425fa7804beeddf6c"
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
