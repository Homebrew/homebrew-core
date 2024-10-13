class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2024.1.1.tar.gz"
  sha256 "fa0e5305e91ef126ac7de52c99a04728255fc694d45b0a9a3f1ca026a44828bf"
  license "MIT"
  revision 1
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "279420fa5e4c90f00c6a98b7bac30248f2a40d917ea0cd7dde5bc0172d5ba5ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb16ebbf5ca8c2e791c3ed79770e0b55a554caa1d243ea2fc7b745a56242c9e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb16ebbf5ca8c2e791c3ed79770e0b55a554caa1d243ea2fc7b745a56242c9e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb16ebbf5ca8c2e791c3ed79770e0b55a554caa1d243ea2fc7b745a56242c9e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4407641b6dcf86ef9fca913f67344de22c88f5c3ead44b028ebbcc0f77a008fb"
    sha256 cellar: :any_skip_relocation, ventura:        "4407641b6dcf86ef9fca913f67344de22c88f5c3ead44b028ebbcc0f77a008fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4407641b6dcf86ef9fca913f67344de22c88f5c3ead44b028ebbcc0f77a008fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "986c7fb269e23ddd8a957b76174775209468590171909c56b64b680fcf061a0e"
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
