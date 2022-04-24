class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2022.1.1.tar.gz"
  sha256 "988756d12527bf9843459a30cc6fbbf2a7d6d75e62326b0387eab6273e992543"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3a6fa0f0ae0f15ef7bf007a552bc4b43efaa7dd072638c2c4eaccd7798a17d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42cc9a88d503135ca25c43e14be5e67f77a452863774b0e8dedfb53d66daf162"
    sha256 cellar: :any_skip_relocation, monterey:       "8ad2b76d6619f177a921c3042ebae5afb6d191893c9ad391077f3318f35d78d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "81617cab5b04a515e98a682047e78627b522660e2ce9cb18e3205fc093d0c948"
    sha256 cellar: :any_skip_relocation, catalina:       "69b19f1dc4702dec14ae7af66b86a92ef26e0384c57baaae8d3f4e9ba56800ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec42e43c04ffadef5ecce6f86f1f96b5986182d201a0a6c6e01ea5975a12fcb2"
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
