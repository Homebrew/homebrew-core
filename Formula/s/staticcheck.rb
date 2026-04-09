class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.1.tar.gz"
  sha256 "4b20d65194e5462264c784f2968de65fcd7aba8e9efa37aa9b1fadc13b29699b"
  license "MIT"
  revision 2
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af7ccb283942ed2d5d9e664ff9fe4cabafb3fd6b92235880cb91788f56d68839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7ccb283942ed2d5d9e664ff9fe4cabafb3fd6b92235880cb91788f56d68839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7ccb283942ed2d5d9e664ff9fe4cabafb3fd6b92235880cb91788f56d68839"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e3560acd6d6ea08702e94582dcad31c674c6e79ac86075688726b716b253804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14d83c4c46a35170f2296f911981bd09dc005cf79dbe117bd92b4e9ab95a081d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9a570c1ab08a540fb88d525a79e1d7ef8b849e63f79d712e841d0441b23cc5"
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
