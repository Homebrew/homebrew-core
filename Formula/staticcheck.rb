class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2023.1.3.tar.gz"
  sha256 "c3a140e3166b0e6025267619de6f8f01e056527c347eacf780be3d2e03f341eb"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea55003370db2b8da27750208559d62ba1e3bab7d38b0bf5b2b1f94f793b5cf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea55003370db2b8da27750208559d62ba1e3bab7d38b0bf5b2b1f94f793b5cf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea55003370db2b8da27750208559d62ba1e3bab7d38b0bf5b2b1f94f793b5cf7"
    sha256 cellar: :any_skip_relocation, ventura:        "c70f5b5eb3eab7b279b746608fdae88f932354fa8a430930361c9b0fcfb18a5e"
    sha256 cellar: :any_skip_relocation, monterey:       "c70f5b5eb3eab7b279b746608fdae88f932354fa8a430930361c9b0fcfb18a5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c70f5b5eb3eab7b279b746608fdae88f932354fa8a430930361c9b0fcfb18a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7e2c9e631994caae4f4f17a52900f82f25dc5b77329f9654f7e6ce0e288540"
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
