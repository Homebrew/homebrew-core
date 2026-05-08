class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.1.tar.gz"
  sha256 "4b20d65194e5462264c784f2968de65fcd7aba8e9efa37aa9b1fadc13b29699b"
  license "MIT"
  revision 3
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bc71600c1105262d91322e597745d92255f01053ca9559d3992e667f7145786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bc71600c1105262d91322e597745d92255f01053ca9559d3992e667f7145786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc71600c1105262d91322e597745d92255f01053ca9559d3992e667f7145786"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3bce61f9a8e23c2f8dd448450bfe1f33d8edbf811021dc5c86487ea9eb9307b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad5b5b2228628ec8abfeb47ef5f1f0b1ce42bee27efee86a0d28268d9a5d5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f013a6d320712298004c2f8811ef24033d9a6c2de6a6c79e7545fba73b58566d"
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
