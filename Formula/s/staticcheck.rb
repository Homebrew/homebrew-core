class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "568d26b0cd97bf3efc7f538a4dcedb4771bfbfadb6aef6ad91d963e1679a2a40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "568d26b0cd97bf3efc7f538a4dcedb4771bfbfadb6aef6ad91d963e1679a2a40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "568d26b0cd97bf3efc7f538a4dcedb4771bfbfadb6aef6ad91d963e1679a2a40"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1bb67d07eab5bde74d2139172abd699122fe426d24bc29419b56b08596c7d84"
    sha256 cellar: :any_skip_relocation, ventura:       "f1bb67d07eab5bde74d2139172abd699122fe426d24bc29419b56b08596c7d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1056fd6a5ef767cb1d90ba19773e15f8c7dc52a95d0a9b0a7bfa6f122322c97"
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
