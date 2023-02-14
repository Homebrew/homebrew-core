class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2023.1.1.tar.gz"
  sha256 "bfc90d478db88bd2fae45125c75647f981c8c5ea6d9941d692c2bbee428df4f5"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eda93c363911360b18e6c9d1317a7019ca13b305a31d9fa8e5919f4061520765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad9586da19836ed539a91deacbf1c14d62a51bef740d94983eb691429d3ab1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "243a15882543193a13ab128a242f1cd25f43df37759239c03856b314f11bc7e7"
    sha256 cellar: :any_skip_relocation, ventura:        "f6ce903bf2b2b07d50c1edf19fd4c667da29d056d91a6f8741834d7216419909"
    sha256 cellar: :any_skip_relocation, monterey:       "6d58c98bf144b63a4e1a938aa9d6fd341c1a76f554cc711e08eb68dd7e5f08bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a801cf85145558e873914d69e2047551ac76b85ac2e071d803bccc4d544a86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d70850e6e96212e1b764aa957c25503b91ab4fe9fff5d2dfcbe212ec8b721202"
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
