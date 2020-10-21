class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.5.0.tar.gz"
  sha256 "1fce13c7222436261b098c8435ae825abcaeb5be83b9a0704aa1f497bda3d50f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "02aa0bbde81a194cbc14bd2168d5d8bb1f1a8f80638b45f08b6cf02779abc527" => :catalina
    sha256 "7a858abfd6fa4a84da7d561ba7db68bd0bc547f53eb7527dc8205a8f757ff58b" => :mojave
    sha256 "c27d1bb595bdb508188e76718390cb58366279c9419e3123bd4371644c5e5838" => :high_sierra
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
