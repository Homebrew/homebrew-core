class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2020.2.3.tar.gz"
  sha256 "dbd109c8a75ca65dcc077b9799b2e49b1c9607a69f55b063243f2ed9e05cc723"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "316303ad3c75386ac655cccb6b8b3403e19e1ebb69ff064ec72a77530adf6615"
    sha256 cellar: :any_skip_relocation, big_sur:       "bac9edcf563533c769e51ef5f0e57fde02cbaf1971e83abd4496013279cea909"
    sha256 cellar: :any_skip_relocation, catalina:      "b29dc5550502b8f28464aad8d968304c9989fd63b4da499d7d8355320f82d31d"
    sha256 cellar: :any_skip_relocation, mojave:        "debe36229bdb50d14cdd32f1727544bf82cd29f8fd269cdc59520bc78fca47d4"
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
