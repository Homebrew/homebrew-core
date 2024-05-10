class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2023.1.7.tar.gz"
  sha256 "9e4c710e79f9b18626ff33d225587518f2005ce9c651eda3b2fa539ee4677a20"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cd68c06d04557cc5051dfa3730a377228fd94f2b89e476a637ff791b09de28a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e2d7c0f62b84bb06b0c6a50890d3f3fdf625e687056e67e79d45692529c0692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db03de30bc6dc6062411795ccca39cc7f57f32c087c2dd4c8e8c5041b6bb6ec6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d175335b9ffd6fd4fb1308ff7fd1b749378c90cbeed7ad67300daaebec301973"
    sha256 cellar: :any_skip_relocation, ventura:        "98c05d2ae5250f0f208c4ef8053ae6ad72398a6c0f3a98d3fa046ed9d05d361d"
    sha256 cellar: :any_skip_relocation, monterey:       "7c7e41b410c98982c90087cff787edcd923ac64345bdb278faf5031557b746dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c95aa66b477825604f646e45315c9e198ff9c2c82a76603b7eb481ee4bd53e"
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
