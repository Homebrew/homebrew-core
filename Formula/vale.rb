class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.10.3.tar.gz"
  sha256 "db5e23fa5356f409c4b09fb37ad13985e404f4a4ad216a5e1b659d72322610c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d2ab672db7722e8938e72980ca9a503bc2281bcc91eb207605f1aaa26d3b062"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3e275586ef94ecde79577a2fce45cdfd5666e3ea084cdf646135a8aeaf25eca"
    sha256 cellar: :any_skip_relocation, catalina:      "ab18f36406506f0250b9067024c674bfb36cdfa737b87ec32a9009bacc8e9c40"
    sha256 cellar: :any_skip_relocation, mojave:        "f57c0467bb39ea4e241027cf72d7f1ac616d61654709da809fcffa9df4797f5e"
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
