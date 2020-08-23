class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.3.3.tar.gz"
  sha256 "97affef6b079a6b67ee8f5f94d5bd1e698dc41676a9bdf53e80b290801a8c648"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fc72a48a445ef10a4f1a97a878a308b7a1dd39bc949cf8fc6e39605cd7a0ff8" => :catalina
    sha256 "3b3585e62c6282fd7147ecda06791744fefc819a9981ca87e755d38d3dba644a" => :mojave
    sha256 "2905466f41551b14e83c335d0f58058ce5756dffeb505472047bd8956218c720" => :high_sierra
  end

  depends_on "go" => :build

  def install
    flags = "-X main.version=#{version} -s -w"
    system "go", "build", "-ldflags=#{flags}", "-o", "#{bin}/#{name}"
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
    assert_match("✖ 0 errors, 1 warning and 0 suggestions in 1 file.", output)
  end
end
