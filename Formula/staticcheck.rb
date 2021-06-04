class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2021.1.tar.gz"
  sha256 "f06e3edca75bb9d1deb5b3dfa7c4bfd0eb85afa1098702131d291a25362966fb"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8da071a5ea7a9b06ec217cf7bc6092e471f862f06f177477a8e2b113f353366a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a79e08daf57188f6783ca725269a968bf4e2a7af6dc492b0cc23cb61c6b6f96d"
    sha256 cellar: :any_skip_relocation, catalina:      "5267b85d80fac5b6b7b986736e3ec1505bc04ec7cd091e8e6f6c22ea806faefc"
    sha256 cellar: :any_skip_relocation, mojave:        "9c9291ba16c61d8ed602523a93df7c3d3260da1e8947f260fe854bd46b71fc7b"
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
