class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.1.0.tar.gz"
  sha256 "957326c072fb6529925c2b46ea948a4c992599fa696bc86dfc0fbbcfef0a1dfd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a61faf7c4db351846e5bb61814edf1d8e07b74feb9796f84a79f54bbd02975ef" => :catalina
    sha256 "6a08b8a8cfef48698c8ddb55cdfe4a0fc49dac862d8f8c5a3a804f4e31c92ec4" => :mojave
    sha256 "a095991ed253b7aa1206927783e66bd3d91b0b284e883c30a49f74949f6677fc" => :high_sierra
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
