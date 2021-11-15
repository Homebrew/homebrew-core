class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.12.1.tar.gz"
  sha256 "0dda66e3f2b14f4be2e4a188d2acbfe4f0087b2086bcb59b3abb4dc87fa3633c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1718d0dc78ff5465305287210bf180e35478bb1b29cb39c57ccea4721b798687"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86dff3ace534bbb2a977ff2dfcfc3ec9052a192addbc962735484d0210d9341e"
    sha256 cellar: :any_skip_relocation, monterey:       "aef82dbce1b0de592d76153cf2e0e3c45574408da336150eff8e0f8641d4de1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bbfae4145d5db0624a28ccbf347561bade9c74693f0c47b92c0f7d49cfb3a8b"
    sha256 cellar: :any_skip_relocation, catalina:       "7b7c2542dffada5e42a955bafeb1f8f4ad234532e343a2ad3c1542789d8c4396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4e55bea698d642edf2d4e562f4c3d77def70b3ada16c864717b34bda05c3bf5"
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
