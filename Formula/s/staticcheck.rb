class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.1.tar.gz"
  sha256 "4b20d65194e5462264c784f2968de65fcd7aba8e9efa37aa9b1fadc13b29699b"
  license "MIT"
  revision 1
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fa0ac41e6937024a35eab5898dc9eb8e4b41f43731bceee0178e2378da10346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fa0ac41e6937024a35eab5898dc9eb8e4b41f43731bceee0178e2378da10346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fa0ac41e6937024a35eab5898dc9eb8e4b41f43731bceee0178e2378da10346"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f4983b0d88419bb1bddef21a2e98cb5cc5d5171faa8d47d2f9bb1fdd1f306fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8d2b9ad713c3bee4b7fefee00cb443b1c1d3b4f805bddeb2b111f8eb851d94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2def87a1599efe047520b5d4fafd00fba2d3df954cbeffdddeb1586b254968c5"
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
