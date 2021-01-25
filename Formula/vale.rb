class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.9.0.tar.gz"
  sha256 "73829e7a14fa8e1e876a24ef6a3562d8a2b5215f444b429fe04da17b5c27adc9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8687613a0848f629fd78f643f8520047d45b26d8ebba33b1337ecab3ad9ae0cb" => :big_sur
    sha256 "f80fd5f1f81d8f98b029314199e981809a35b68a9f433c5fccdf139416a222f3" => :arm64_big_sur
    sha256 "21379b4aac73c5140f8782eabe461cb2bc6bc03f7305ad5ad23ad054b3d29f7a" => :catalina
    sha256 "58c5c4aa11d98d062285a8b7bb0f1a8f5067f3a303dbba4cb9a90bcaf665d74b" => :mojave
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
