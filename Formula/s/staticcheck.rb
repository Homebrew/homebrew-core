class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2024.1.1.tar.gz"
  sha256 "fa0e5305e91ef126ac7de52c99a04728255fc694d45b0a9a3f1ca026a44828bf"
  license "MIT"
  revision 4
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a154301acb8a3fe0b3851a8a6bfed2eb808972a831e1aacb90e12db1659d797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a154301acb8a3fe0b3851a8a6bfed2eb808972a831e1aacb90e12db1659d797"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a154301acb8a3fe0b3851a8a6bfed2eb808972a831e1aacb90e12db1659d797"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc5ce99ae6a04d01df3ba93e4f22901a7490ec0454467d670891da88f8156ee5"
    sha256 cellar: :any_skip_relocation, ventura:       "bc5ce99ae6a04d01df3ba93e4f22901a7490ec0454467d670891da88f8156ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ffbecfd6893abb420c8c5c74773ab7e0829a39b0b6f642609f3f0f9bd08ac7a"
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
