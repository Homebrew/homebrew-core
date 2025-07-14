class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 4
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d24c73aa0598dafc875025951862bfcd04bbef62059129d1588f601d04fc58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d24c73aa0598dafc875025951862bfcd04bbef62059129d1588f601d04fc58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97d24c73aa0598dafc875025951862bfcd04bbef62059129d1588f601d04fc58"
    sha256 cellar: :any_skip_relocation, sonoma:        "83239474b6f3f53be115968cfcbcd3e133968577a7d7d4cd05e24ad5109935cc"
    sha256 cellar: :any_skip_relocation, ventura:       "83239474b6f3f53be115968cfcbcd3e133968577a7d7d4cd05e24ad5109935cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41393ab1609059ba804f3fc4f77bc631e3e843fc37c4e0bf791e45162d9515c1"
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
