class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2023.1.5.tar.gz"
  sha256 "fd231014b8d9668dc3d2d583a54c7988453c9b5a42e4ba681a9b4c5be6744546"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "770befb587e5853b5b4d54068c6ebbecd7db8a2f42628ae27ee979c3a425a93f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aedbe1af0e12720454a9b2c4728525ba23208865c38ff448d6285d51c3edb558"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3afc69cc2d66a64b0dcf966df1a89b7a5d083245b2cd0840a49b1fb46545592"
    sha256 cellar: :any_skip_relocation, ventura:        "1edb5c68d15764852ca462097e53d7c5b618388b7222435d7e3cacdb84056fe0"
    sha256 cellar: :any_skip_relocation, monterey:       "001e8cc21cb9f26545aa03a1caef8c74eea0ae14a55c4453ef9d3713650c2c5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3b4eeb1ead02433dd055be5bbecf6cbbcf00f3dad46e1da42a42beaa549abf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e499c2bdb9a2a3eb352879b1fac8592b1bb0422522c24eb370c8d95988c8689e"
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
