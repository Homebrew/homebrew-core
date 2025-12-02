class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 10
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b585be62a7ff056e7f3a041679c50defe0cec2340d1245ee85689b553fc8207a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b585be62a7ff056e7f3a041679c50defe0cec2340d1245ee85689b553fc8207a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b585be62a7ff056e7f3a041679c50defe0cec2340d1245ee85689b553fc8207a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd02e3b5a92803d1a8998da309dc79dc58904e2637eba895eb9352216782623a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "686e0d540024ddf21813ce6fd216496ae4230e40c09c2f9a01dc04310681e3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3cdba3c8999cce182e57c1ac0bb33075d5fbd3cf96b3d7d385d0b801929737"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/staticcheck"
  end

  test do
    system "go", "mod", "init", "brewtest"
    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    GO
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json .", 1))
    refute_match "but Staticcheck was built with", json_output["message"]
    assert_equal "S1021", json_output["code"]
  end
end
