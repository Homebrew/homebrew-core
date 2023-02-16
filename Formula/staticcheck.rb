class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2023.1.2.tar.gz"
  sha256 "c112f8f5f41866729bf7e8f83881210228d0d6e2c037f45870b5d90ce239e4be"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bc995f4fbac4e70f84290a4f088e09eee9c15208bdf7a63aab2f80ed0217cfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bec0f55944a58755fc5cc0d7055071e372f099ffc86bd66c607d7b5baceb927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31b243e0bd876bea5ef1bcc6122b49da7dae827cbe9f347e7aae6b9eee6118e0"
    sha256 cellar: :any_skip_relocation, ventura:        "a482aa5fd819589bac268ae54b29870786ac084d295724e492ca2ff701f85b05"
    sha256 cellar: :any_skip_relocation, monterey:       "30a13e6b26c8f2d2c2b425addcf11614709ca4f809498204805bb659c4932073"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1e512a66ad382308b5954698524bfb9a49e5c822e418e5fa1e5ec666be81568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f05f248cc84e7d220b2af7f0e112d5aa6a3eeef676a23c5c159cc3591d1b7f5"
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
