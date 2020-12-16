class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.7.tar.gz"
  sha256 "21a43c7122932d0914bd023ae412432aed3e0112473bf809b542dba3986ee4bd"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c851336b346759fdd8443e8dfa80cd724fca3158c24b0d887943dc2936f7b54d" => :big_sur
    sha256 "041626949061c7d96e372f5a31c464b3cf5cfd156923dc1602af55af711b59a6" => :catalina
    sha256 "31d4fa32a4f88160199cf57ac6edfecc2cfb2faf42f32b0c71821693d84b2330" => :mojave
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
