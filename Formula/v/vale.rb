class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://vale.sh/"
  url "https://github.com/errata-ai/vale/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "fcc7177d2715283eede6482c80cdba1aa385cf8ea6046de2efabb6a068a6929e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f181d5fc514b1bb9e598762861f9226f3a87019fe1e6f887186cecdb846cd705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e415c0b6c101cc42cc3aae7da6069f3c9d1a86b2577fbe5e72b753a8d8708c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47d5d8825029e1550685173b01a13cdc51e51c428964d85d5ea314bfc9393567"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2452976073132f2972789c0fca388ce4389d3ec50ee2d162228a72d63b21fc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c89032454282bcf320972c2570cb0732bad1866384a4174f418e8840d9b58241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cedc964672bf5e02464b6257e75ae09d0c177b4cdeb1b9b9afc72c95fb7d626"
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
