class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "9c530722079cbd8b700ef8385d5bded7c9a85d112831ca2c6e5ca073971065ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54b9b7326439f8815904c305f0f36547e8ffa31651e10351fa95e0f8bec91e22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b834be1cc08dc3b6017b6e10f06a13492174bbf6aa4ba208fc7b76c55cc0c8ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c767bb17a27e28208148679a52da660bcdfabc64ccf03147390cf0e9714bd2f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "86ee872d13d60f3f82ae99fbfa5f14c9b38e48701df32a01222457ada47dffc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "009dc21ec0252315e9e947ac5bda2c1cf72e9a15758c68406d1c376a07cfca07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe88b1db972209f0d6ed88d3c7d69013c2230406fa2977568e3591ccc8f57b33"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
