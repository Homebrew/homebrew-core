class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.2.2.tar.gz"
  sha256 "bf90648b364c36eecbf2c7b510439507e27d8107016f23cf4f26b32550cf1674"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9adcdb7c49fec71387a0cd4a4beb8c81e0bb5467eb2e16db27a02ab94c0d4b2f" => :catalina
    sha256 "fcf77f5465bef0f72403fe09154e591cecc03637d85bd0bad767fd66c6ce9a3c" => :mojave
    sha256 "2294ed7b45cfd56714e540a89f408345e925cba457b64f5dd177b64257a218fb" => :high_sierra
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
