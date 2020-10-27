class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.5.0.tar.gz"
  sha256 "1fce13c7222436261b098c8435ae825abcaeb5be83b9a0704aa1f497bda3d50f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3139d0fe34741593dd01170b127f954f0bbfd2700f55bf8d63004010ca0ca113" => :catalina
    sha256 "bd07378867aa44eed15f80ce9722a83b8bebf2438fd85440575745561e62fdc9" => :mojave
    sha256 "b94fea2244a2fa5e497f95a0c022abd531e4c3de19897102190a8d5f8806b73b" => :high_sierra
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
