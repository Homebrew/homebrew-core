class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2020.2.1.tar.gz"
  sha256 "3603c8e640cac8c4537c6748025db12f154f844091d1b47a3fe303a83da31029"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a515f5fc81be1069541c86a0dbb0c10ce406d5f63420e25d6736eea2d970f011" => :big_sur
    sha256 "6b7c908b171158a2e7bd736d903cf349542d504197a753c9967be8fcb42400e4" => :arm64_big_sur
    sha256 "c207bf44becf6d82ad8fed9eff75db5a14a106df080fb90eb8ed6e1b7a0c0375" => :catalina
    sha256 "2e7d67e9a2aba779e109c18b0aac9729438033ae3666e332b83f2a9c5c84f3fe" => :mojave
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
