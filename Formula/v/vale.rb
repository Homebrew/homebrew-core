class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "3ae991e82eec889f54ee64a1c013d1f2bdc0f95d4a03ac7ff44228516606e737"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a577fe5af4c6c9acd3b2de01d1506d70c2fd22c34a277513c4d7bfecbed78ca7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9464bf61820da7ab8c8a327972b800ad56d812c6058f438b9737052d7bdec3e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ed75e5c6fe52bded90f1e29e9c8c6fe5dea8c0d1455d67dd5b68eef3a6b4b27"
    sha256 cellar: :any,                 arm64_linux:       "2bddd80171f2207a1fbad130ee1a57eb1305fe1246385ae42d9457d6fda4f5d7"
    sha256 cellar: :any,                 x86_64_linux:      "c8a627895fa24c04a4fba37ae215faea2e53f200fda3e032873651f425b645ff"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/vale"
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
