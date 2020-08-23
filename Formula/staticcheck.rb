class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2020.1.5.tar.gz"
  sha256 "aa57272dd96a8d93af74c504c9a8f9949712e1983512830a0b82f3afbd96b4ac"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5022d10d89057b3485965e66a3288db9551099ce63fa58d1db510e88837bc0f" => :catalina
    sha256 "5a350b5e8a17c65e98604d0dea95f1be801fef84c470bba0de4b923be9d6152d" => :mojave
    sha256 "999afeae7e6ecd76aeb294a6e0592997b8bd8529afecfb3298a51562e0257627" => :high_sierra
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
