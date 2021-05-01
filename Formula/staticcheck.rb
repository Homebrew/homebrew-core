class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2020.2.4.tar.gz"
  sha256 "a13362c6cce037d18ff2ad092725aa1f3563f3c1f05fbc6749e08050dbec742e"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "468514b52d658438aabf67c493e3a766d0f4448d86d428a41d71e687ff806402"
    sha256 cellar: :any_skip_relocation, big_sur:       "0064e0095e3195f6c1d658a2c27ce8204a898ca59cf379f8f2de475e22e554f6"
    sha256 cellar: :any_skip_relocation, catalina:      "7891492473c216470a127086f681328018b40b31adb427c4b10793cc7235d2b6"
    sha256 cellar: :any_skip_relocation, mojave:        "19df6ce2ace845788b749adea55e6685211a314ad044e33036c60ed2c438bf31"
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
