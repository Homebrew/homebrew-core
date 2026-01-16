class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 12
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fe5c255184d16a7fe5c4544a91d1dbaa5aa8b3381fe6e01e1d469c23b508050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe5c255184d16a7fe5c4544a91d1dbaa5aa8b3381fe6e01e1d469c23b508050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe5c255184d16a7fe5c4544a91d1dbaa5aa8b3381fe6e01e1d469c23b508050"
    sha256 cellar: :any_skip_relocation, sonoma:        "45b312957633ab3f7ed755ec5af2b943fa1e737d40996fb0d16d7d5755b47b1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e87efebf3a59df352ae5a94d10fdf200725ea1e59725176af75efba88d9618ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad04df5ef982689df09ce323cba252c502fd79673fa4dc20c6dfbc6dd7197ae9"
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
