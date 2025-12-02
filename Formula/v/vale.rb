class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "a6811e19c0ca8fc453da98238c2ffc7c5d5d1e77346d72d24fd47c09302fd7c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8de7318150b31fa1b69c7a2177238b2c1aa6cabfb2a13494ee30b5c287cc263b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63ae982fd3a5ded522999879e982ab8b0e0033c118e4eb261d0b09ebf90b0d5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ff6d4482cd580a3db3c4f90959c3b88b227eedcaafe21ff96855abbef5e28b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5fd2c5ae3597780cd4e342cbbaef0aec26975ca0fe64a0e3bd50efa0e6a8b4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae47355bd4765a8b9e8501b2c67b1deee1a33d6aabbe8d93b64fa8555e5f7e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aad10ecae4057bb92bc9dfd77c9a5fd90fa1ea914f28488482c02266e619f53"
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
