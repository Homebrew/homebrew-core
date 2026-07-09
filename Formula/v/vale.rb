class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "f2dc8fd38deb4789a780f5e2f1fbb8489c45333ccd6e923999e528d78efe297a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d2e7ddf78bfbbd4e29a2a7936655649184d59cc84c4397a5e83caef1d2750b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ce773215189913d907ff5b629570b001f13f6ba38ce5045f27046540cd970c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adb30754110f38eb902af0e94a6499afad4c793c003059ca1f07f991cbc90fe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c56e99b22b93c34a9a40d397db334c7386f01685cf2405188e01abae476baf54"
    sha256 cellar: :any,                 arm64_linux:   "0ebcc6a5a73f4dd7160a62a91884c45722189349d66f6eae02759bcd486a5368"
    sha256 cellar: :any,                 x86_64_linux:  "5ad30d5889efaa6ea4abdbe1f16aa4d65628e7a372c3806f91eb4a308c111d84"
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
