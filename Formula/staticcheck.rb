class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2023.1.3.tar.gz"
  sha256 "c3a140e3166b0e6025267619de6f8f01e056527c347eacf780be3d2e03f341eb"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd651494f08137d48328fa67f233a0ed2240c789b291a9a07e7c16142861a92c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd651494f08137d48328fa67f233a0ed2240c789b291a9a07e7c16142861a92c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd651494f08137d48328fa67f233a0ed2240c789b291a9a07e7c16142861a92c"
    sha256 cellar: :any_skip_relocation, ventura:        "7b109b5a726cc27b68ae5dc85760a1686ccce982d685b6ddcf3db2001f9aa778"
    sha256 cellar: :any_skip_relocation, monterey:       "7b109b5a726cc27b68ae5dc85760a1686ccce982d685b6ddcf3db2001f9aa778"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b109b5a726cc27b68ae5dc85760a1686ccce982d685b6ddcf3db2001f9aa778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a260bfbc44bbff085430a44aaa4ac9acd4ff94695e9aa0cfa21d6f5050d667c9"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    EOS
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json test.go", 1))
    assert_equal json_output["code"], "S1021"
  end
end
