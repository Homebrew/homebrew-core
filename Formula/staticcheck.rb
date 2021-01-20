class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2020.2.1.tar.gz"
  sha256 "3603c8e640cac8c4537c6748025db12f154f844091d1b47a3fe303a83da31029"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27241d832369d54e2c75db20d984c841b96519e9474dd74f8e2bc4e92d9d0c41" => :big_sur
    sha256 "ac3fd9cb21581df6bee190217b4e68af401da99c4a201b540af960505dab0a0b" => :arm64_big_sur
    sha256 "16379ebcb571ff00903bd0894afc34b4eacf4d7076781afb2711816039c7db23" => :catalina
    sha256 "7e17edd850f6cf0c49a6c5fabfb10ca3e489f1f33a38595d10de621e5fb13175" => :mojave
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
