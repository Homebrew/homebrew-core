class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.2.tar.gz"
  sha256 "72fa00a4bef32ab52aa3ca916e70108ca021ef3c35dda555350c0b670c432033"
  license "MIT"
  revision 1
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9670983b78481a2eb5207212b287a7a00b8f128a2ea2d898112589d58780c004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9670983b78481a2eb5207212b287a7a00b8f128a2ea2d898112589d58780c004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9670983b78481a2eb5207212b287a7a00b8f128a2ea2d898112589d58780c004"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d0ee56cc7972b5e0fd332f85b47b01fbb2a423a8477aab19240a433127342c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b3a69701416f8a295358decc1bf75481eba574ef924667a19aa7253784b9f95"
    sha256 cellar: :any,                 x86_64_linux:  "ee57cf9b4cf1f13e3e64c3958b1b1bd4cfce7b084d84f76c126681929da32ece"
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
