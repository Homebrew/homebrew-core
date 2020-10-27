class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2020.1.6.tar.gz"
  sha256 "da1dd86ac97ca8864dbed6343fd38c3bbcf83f7a1a4526e56337452698b27c95"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d50abbd47adab10e9f8fb4356abb678e0f35db3eee15fd503daa4d8617897848" => :catalina
    sha256 "d9fd2811d193e5a61c7a11c01cbbb8e541f3992854d4a33c9be9004ecaa74395" => :mojave
    sha256 "84b99eefde0756c76933ba759e03c884bebb9ddfa0eeb3e44db032f31f7c5cec" => :high_sierra
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
