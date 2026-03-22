class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.14.1.tar.gz"
  sha256 "2b56cb18274a881c8d18d4751cd8c05283529ca8e4934fc0ff8f059113131c86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6619a7bc66253b207fafdffa6b28df6d4aa1378f1f4ee54ae4f27bcf1b8a960e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c104224bef2de6a2b088c9937b783a5829e49a7e9753f18ee106221b239d9a27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a85e4120641673acdfe27ffa108fdf8a9c3ec8fdcb0aafeecd010fd2cc1087e"
    sha256 cellar: :any_skip_relocation, sonoma:        "02374cad828327521c74a84913e65f6e95411b55e2cb100176488f2aba11d8ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6875424c14089f3588dca004379e3b61f1b6164b9c1046c844b5afe677f7c34c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9d077e7fd506ffd74bbb83897d58798762202d3af03e0d511243e15d69565cc"
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
