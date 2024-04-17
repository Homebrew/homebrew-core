class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "cbadae7347fb6ba45eaeb9ace367d21b6665aacdc50ee744b76bddd3d7a84baa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bbab017ab2bdad91bc65f067ca067f1d0f35d528f29be11b16d59fbe97eeb2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8677a9b06e33f8c7623720d79bd0a8e5ceb69cd67d3f25ae2f16bfd6583f50a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f84d55df8ad05f00fd96b142d9646ce2bc016cf7bfb4a128f1bb8fa3f6e80b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d893afd8e5fb62205d84b879ff61431c47444504ec5c46c085529deb0559c14"
    sha256 cellar: :any_skip_relocation, ventura:        "d8f52a5f56b38624da943c8c741cd0dea482756e06598a992260cf70183d1dea"
    sha256 cellar: :any_skip_relocation, monterey:       "c4153d1891c96d64ec7f49374ca14e65099d5684d27f29fca86db116f982eb2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54269be9aeb1fef9dfe78828f52c65fc29e9ab286b99e9acdb57bc09429ac71"
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
