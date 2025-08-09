class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 6
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cc91c3199d10ecb384c672d77e1a7cd96bb8ceaf9dc1822d18b9e80a43d3ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc91c3199d10ecb384c672d77e1a7cd96bb8ceaf9dc1822d18b9e80a43d3ec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cc91c3199d10ecb384c672d77e1a7cd96bb8ceaf9dc1822d18b9e80a43d3ec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "46575b0b83b7655596a554d1cf01a183a11f34f0f630163e6498685d38914500"
    sha256 cellar: :any_skip_relocation, ventura:       "46575b0b83b7655596a554d1cf01a183a11f34f0f630163e6498685d38914500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d7794d0df324bb1fcf2dc614fc6d7ee2c2c7bbbf52326988b6151729cdc0c1"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/staticcheck"
  end

  test do
    system "go", "mod", "init", "brewtest"
    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    GO
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json .", 1))
    refute_match "but Staticcheck was built with", json_output["message"]
    assert_equal "S1021", json_output["code"]
  end
end
