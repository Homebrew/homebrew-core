class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.2.2.tar.gz"
  sha256 "f957eca5ee25bba46711433bfc320e0e900304ebb89641264bde256031926139"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f9dd05553e1faf09714fb5bbfbed2fa228577d5a55c1457233d0280652dcaa1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f9dd05553e1faf09714fb5bbfbed2fa228577d5a55c1457233d0280652dcaa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f9dd05553e1faf09714fb5bbfbed2fa228577d5a55c1457233d0280652dcaa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a257e28f6c5bee671cd36d6f8c29c0761182068884dd21117c0fe9fcca4fe6f"
    sha256 cellar: :any,                 x86_64_linux:      "83c06e974ea0d97b299d45604efd8ca585b6a4db887e84ceb17de662ac61dc7c"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
