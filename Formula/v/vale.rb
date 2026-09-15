class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/vale-cli/vale/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "e069ec49e8870da8f099569b68a15e27f73f5dc5d53eb85e4c84365352c7e864"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "040774f34895e7b33b36b72785eef7b8db37d17a7ed7ada4babea7a994b5e959"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22cec5351c9ba2c0905d8e51e7b88942f8e7811be52a16d1dd2fe76d8734ae27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0acde66835806cf348060d78bc68f9360ca71df139cef44ea3d37d94507fb524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6934fb9abced1a386083160d7dbb03608d74c980adefa896d531e4a566e4e78b"
    sha256 cellar: :any,                 arm64_linux:       "6e82085826b2172dcce34b27643212919f77ec5d112e5cf0429ec7ec0587725c"
    sha256 cellar: :any,                 x86_64_linux:      "378e2d017e933b0fbb382d8a2c7904d3eaf948e8f54e13966f4acc7f5824c2db"
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
