class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.6.tar.gz"
  sha256 "86efac2a5701499f8829efb945f513aa978a8efd6ffac686985ef1c5f0306b79"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7dc33a601468c62dde94b20214e343f6a0d95e3ccfaaf303751e620c6fe14a4" => :big_sur
    sha256 "543af6e4a7660e556924f268c090112fc1ccc508b74ce313c2ec30212b807443" => :catalina
    sha256 "96e3a3fc46d20ab9612ec2425c2039fcc9f5307eb492ef99fb2245c45d76a2c4" => :mojave
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
