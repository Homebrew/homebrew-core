class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.21.2.tar.gz"
  sha256 "d0766da43f7b402f2850b87b1aec8f13174d122c5e364df13b8961cf0deb2bac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccbba396d94efe44b147029bda62419cff6cd5e7a3220dfcd615f7fd8b765ba9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be874bf95a84ecbab6f2760b828f03080599d2f9cc64eb54ed4a21b434dd659"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71c3cf44065e06dc27c1e889557975cd8d0691b9ef6c62e55cdd65c2c75df836"
    sha256 cellar: :any_skip_relocation, ventura:        "b9a925e0c2a308e884cbb348fe8665fa0492b51837ea5390a0369b6863218c15"
    sha256 cellar: :any_skip_relocation, monterey:       "b7b052b5cacea0711405d8bd9fde1357e23287f90ce4bc76d7b7257f8681a9f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6679262ca8ebf5964d469240547080df1a9ae5b606b7ccb33deaa2576ac6127"
    sha256 cellar: :any_skip_relocation, catalina:       "f2d5877ae5783dc267fa3459d7ae29a580ceea2c636339022f2a021b8782f1a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff0a980214af95c7b97a5a6015400bc8519f80c9c530c1c44b01e2e8566b328"
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
