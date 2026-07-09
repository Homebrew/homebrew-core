class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.1.tar.gz"
  sha256 "4b20d65194e5462264c784f2968de65fcd7aba8e9efa37aa9b1fadc13b29699b"
  license "MIT"
  revision 5
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7982e8f3982059a56623de7e69c781e3c1d5e9f7e65003352ec3587c8a713622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7982e8f3982059a56623de7e69c781e3c1d5e9f7e65003352ec3587c8a713622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7982e8f3982059a56623de7e69c781e3c1d5e9f7e65003352ec3587c8a713622"
    sha256 cellar: :any_skip_relocation, sonoma:        "f16e2fecd3c87c6b1ffc72b98579e9b8757671407cce80c6f9f4b8e18e840c09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0ccb6d8a842d9247233936b13bfb0efbb383f2e004c14fd3a44970fa51392f0"
    sha256 cellar: :any,                 x86_64_linux:  "3c2181fdc3a793aa81c4775381b08703d95a6585f2e9a34d88d6fb0e8baad516"
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
