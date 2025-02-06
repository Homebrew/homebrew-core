class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.9.5.tar.gz"
  sha256 "3608cea12a91a35e2197693e06410bc534e3bfb9673f73aafe90922b0037d046"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3690a2f0b0700e5741e5f7f3d01a76bb6d29a7d9e5f7746735133448af505dd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d62fea622325a532476be70c039f0a90d30c6b7a27103f5a4b673047d9978846"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68e92053ab948fc2eb694803b8e8d6ebca34072cb2ec8633646a337959429a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cf12e170f2d1fd4de48cfb39419c88c97ff3672871b0f7a72d0932b6b0aefbf"
    sha256 cellar: :any_skip_relocation, ventura:       "cc20a39f447410fc48028cace1c2814d1adc47625c1d9c514452138502a51ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37bb37306c8893b14685b13294e66a50cad505ca0353ff74a140c30828ae64e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~YAML
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    YAML

    (testpath/"vale.ini").write <<~INI
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    INI

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
