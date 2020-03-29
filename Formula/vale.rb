class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.1.0.tar.gz"
  sha256 "957326c072fb6529925c2b46ea948a4c992599fa696bc86dfc0fbbcfef0a1dfd"

  bottle do
    cellar :any_skip_relocation
    sha256 "bba63c41883a4397529f0b6e3af54257f79164edea76c7971a20e048ce55eaed" => :catalina
    sha256 "a917a62950f9aa3d2bad74433c8619e2a709a98a8c4afa4c40d21930079fb61c" => :mojave
    sha256 "fa8c2cf944d2571eb4b3e0e318c58345f4abcab49f6522f4bfc2ea084fac3544" => :high_sierra
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
