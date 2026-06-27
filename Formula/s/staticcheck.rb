class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.1.tar.gz"
  sha256 "4b20d65194e5462264c784f2968de65fcd7aba8e9efa37aa9b1fadc13b29699b"
  license "MIT"
  revision 4
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0712ed966b17bacc79132e8881fe2f2aa607edecd2086b45e14c47b5e48facbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0712ed966b17bacc79132e8881fe2f2aa607edecd2086b45e14c47b5e48facbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0712ed966b17bacc79132e8881fe2f2aa607edecd2086b45e14c47b5e48facbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c199961368d75f9c7e4a2c710762707a9b8f29238597c952d8ba9dfc1e72d7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24b3d447d2f9c49a37b216bd1f79d335aaf2819e5a682a05d3326898ce6f520"
    sha256 cellar: :any,                 x86_64_linux:  "a88a0e8f9b3d27ff8042bb4bec45d9324543250f146b8ae549274edae897d1bf"
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
