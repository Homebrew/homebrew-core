class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2021.1.tar.gz"
  sha256 "f06e3edca75bb9d1deb5b3dfa7c4bfd0eb85afa1098702131d291a25362966fb"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "673447f223d60aa407250600dc25f19b9b4035f214407cd20525ee80c6b0302c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e51d03c31f6ee706f5269dac147844448397310dbd14f45b7a8b74997e0405c4"
    sha256 cellar: :any_skip_relocation, catalina:      "ca89c0957966e81a27ecbfb310f5ddb283de3e9531c78587022ae22fbdabbb22"
    sha256 cellar: :any_skip_relocation, mojave:        "aa8c4ff32f667505f14fab71e510e91b2da18e2c32385e4fdb1eb2939b8c71cf"
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
