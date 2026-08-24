class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.2.1.tar.gz"
  sha256 "8d807cd909f4481d6777f7707e5ae75dcc399e14d68ff14a3c814731826e0dfc"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b10258c62f973397500212d9c9c61683d2c1389a54cb01521035f944601317a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b10258c62f973397500212d9c9c61683d2c1389a54cb01521035f944601317a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b10258c62f973397500212d9c9c61683d2c1389a54cb01521035f944601317a"
    sha256 cellar: :any_skip_relocation, sonoma:        "74b9f3159699268b6ffc2fa81f2e62ec577ee9d6a1b0f252df5ca5132eae3f68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f775c6c4ffaec0e2a5b9133bab4e5be433618e38d2456c79cb8532556015ca"
    sha256 cellar: :any,                 x86_64_linux:  "1637a4d425344162b967ffcb58a49ddfa1f142212d52f442c52fb4e6e06818c5"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
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
