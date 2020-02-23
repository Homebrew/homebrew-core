class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.0.0.tar.gz"
  sha256 "9e449a0eae1234006ebc6c204a248998ca1b6c256e7eedc315a332ed1e1443f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "55d0d445b8a784ed4b3b4a3984607b47a7de9e08f965023eff3b9e4729be3d91" => :catalina
    sha256 "76f9d344221f5121ac43b32874a303ecd2bb935bcb8d26ef39f8754046c46e3a" => :mojave
    sha256 "7aef1f869c6f7d757897a106d22416741489f38b108c49e1c2347392b8bac045" => :high_sierra
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
