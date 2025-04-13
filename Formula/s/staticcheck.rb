class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 1
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdfccf0daef098c323090f84334bb145b6c48da9587cd40cee6fd4d71db3bfeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdfccf0daef098c323090f84334bb145b6c48da9587cd40cee6fd4d71db3bfeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdfccf0daef098c323090f84334bb145b6c48da9587cd40cee6fd4d71db3bfeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc21362b5a7567bdf9041359ff6661df40e3e793cb0a1bf120efffb219d3f17c"
    sha256 cellar: :any_skip_relocation, ventura:       "bc21362b5a7567bdf9041359ff6661df40e3e793cb0a1bf120efffb219d3f17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "347107bbe8efbff2565326aae4e0f5f05fb8637dee773a8a9667710de54bc319"
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
