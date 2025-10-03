class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 7
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc76e2d678df0f309499650e7ba0d36d73e7241e9664fc19365ff718c882beb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc76e2d678df0f309499650e7ba0d36d73e7241e9664fc19365ff718c882beb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc76e2d678df0f309499650e7ba0d36d73e7241e9664fc19365ff718c882beb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc76e2d678df0f309499650e7ba0d36d73e7241e9664fc19365ff718c882beb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6600fc1d98f050fe14cd7f05adf9cc80d6f0cd447c1c3d8857c97a3662d24498"
    sha256 cellar: :any_skip_relocation, ventura:       "6600fc1d98f050fe14cd7f05adf9cc80d6f0cd447c1c3d8857c97a3662d24498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822ed472184f0e3f5b920184dd9829bc78c80dd3c9866ff7d4e5a4f0081e9e04"
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
