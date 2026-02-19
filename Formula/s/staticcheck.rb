class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.1.tar.gz"
  sha256 "4b20d65194e5462264c784f2968de65fcd7aba8e9efa37aa9b1fadc13b29699b"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "698bfc4a0cb19403d631b384bc02046d8783524ea58831f379bb8552aeb166ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "698bfc4a0cb19403d631b384bc02046d8783524ea58831f379bb8552aeb166ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "698bfc4a0cb19403d631b384bc02046d8783524ea58831f379bb8552aeb166ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "5617fa4db20403dccfd8907340abd54ea641817965ad3516a7dd94587eff6355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85589cf9fd5d51b44ae601e0f0b7e4f571fa537d45b9f2b37a989087dfdc14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615ca90bbf56f798014b1950ff5c2b0cc5afcd7646225ca7cddd1f1c8b87395d"
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
