class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2021.1.2.tar.gz"
  sha256 "c3fcadc203e20bc029abc9fc1d97b789de4e90dd8164e45489ec52f401a2bfd0"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "001fde64210cea407dc8ea447b19f52ba0d3b31ecda2ed45707f78b3344b9cde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0907cbe87637251cf796b95c50b8fa6adcb4d2a9eb2f04c7a80494c49b190f9"
    sha256 cellar: :any_skip_relocation, monterey:       "66fc3e138a76f2396906a21cac9267769d4f4fb875236a596b4fec1eb1fde755"
    sha256 cellar: :any_skip_relocation, big_sur:        "528b164d38c92f25c20144f1033382e03ad7561dc1ec4045eb490a7f617bf79a"
    sha256 cellar: :any_skip_relocation, catalina:       "3cc17b3514e41e2ab3d56e82ee3b88322f8fe1298fe7441abc52567538463a58"
    sha256 cellar: :any_skip_relocation, mojave:         "9bbaed1afaf4c35aba8cc8aeda28f9f34d518f067b401d413f30b8bfdeaa4d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2073782f457c8218c98996d7e368f6fe38f79b57939c10635e17b7d31511cc9"
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
