class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2023.1.2.tar.gz"
  sha256 "c112f8f5f41866729bf7e8f83881210228d0d6e2c037f45870b5d90ce239e4be"
  license "MIT"
  revision 1
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daf5f4d93ead3bfbf18dae5bc1ba65a5e15012ceb8dc6e2ba07dcdfa282593fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3acfd1aa0aee2318fcb8c90b768c704019ce232cfa0ad089992e4ee379efef14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e412f3f69e4d8131a09b257a9c52950e09f78235f2b414530d900ec973c31a34"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a1e6f3503075326cabb7a583a67fe2d34a3c8c7f780fc9fa6423a3413711f6"
    sha256 cellar: :any_skip_relocation, monterey:       "d71b8a1b2e80b6bf34e709ba08efb7c625457afc87db477c05ea796be4add5f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c5f867d35fb0a1f24d0c64d3d8f72c410dbe616bedc8fd7c4d734ba2df44c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15e9c3d88500747c0a684296a921c2bd0e2ace74af17e81cf78253f72152255"
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
