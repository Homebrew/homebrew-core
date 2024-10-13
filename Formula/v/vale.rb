class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "e6a4cc2eff9c6645f26ca51b66df66a088045b8084949bb8c61c4a6cbe10673d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78416ee08080df072c9b5c3b36fcab330fc91a7cac5bf8221c4f5efc2caf73e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "449a8e17c33966be99b1fee2ac8ea85ce466346f7a3964e98c24a00d00476abc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa78ca45cf8fb6eb8dad509856f5713bc026173a230a36d80720fbddfbbb2d3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f126f70f182e5cd8ee2c5a33180cedd901da4d7be4096e2a3cd4e5cf74af210"
    sha256 cellar: :any_skip_relocation, sonoma:         "df08c65351060d38fb823606838e889e7c4291b81f637dadb0b170f754eba979"
    sha256 cellar: :any_skip_relocation, ventura:        "6d603ae88be242da7eea2de44bdb854da0bcd43746915e39541d5be0ed0a978c"
    sha256 cellar: :any_skip_relocation, monterey:       "12f921b42cfd158d9f3777032607a5a92c16558192faf84351fac19774c56722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc302691858be4b28014eed9b5d21c7343f64ae35b8cceaa96066320969a3b53"
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
