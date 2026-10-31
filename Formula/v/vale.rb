class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "c63c9c9b415d55616c112c04ddd98fba5e94bec0e266bc576e36da6aa7d6b53e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0199ab66a55f7b30ed0c9181568087469748c57390ef3f73aaf31371aabb4ad8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "713e2ec29c21c1a7be12653fb10cd8fc9a178cc7550de5bcbd2b8904b0f066cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20e22ec83643e727e1567a4beea1e24469af1b8725e6ee517f3ae3e8ea4d83ae"
    sha256 cellar: :any,                 arm64_linux:       "8f6ee8a8a50d72fb435d36d91c872eb94d83eccf900f56647505c5620ad897e4"
    sha256 cellar: :any,                 x86_64_linux:      "0c1194ba5af2325440437c5cd9dbaad8f440b10095a3755955a3332835c42fc8"
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
