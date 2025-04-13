class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "12795c72a5628ebc22d46a33b878519c5ba18e6d665271893bfa24cb1f864f73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6a8cc077ed0f5ad8be3719f3d750bbfb1dbf7b96fa54ac98a074143fabb0768"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e73d48b35eae871854648ac295bee93b7186c8d523928ffa6eb59086f2a475"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f698c1ab684c91ba6a242db3b54443907112853b6d32dfab25346f412f47b280"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f87db0ff1f2b0eb1e974f90fb3f0c047912be6638b980c1b353128d5aa00a7e"
    sha256 cellar: :any_skip_relocation, ventura:       "1837469512fe4b948a9c023360f72d1855013cc36ac17f4755ffd4c4ec75634b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "541ef5a35a92c6951d87b2d521a8d67b6acaa5222bfaee5c0afabba320f1e97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa4df31797b5d35b2dce4cef399c2ba428e0d7095cdaa0737b4f948fd25280b5"
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
