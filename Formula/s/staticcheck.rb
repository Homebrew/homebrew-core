class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 8
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04be74b836b4249fb5000aaa75632821e5ef41b0db6f58af82edf9b115b01523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04be74b836b4249fb5000aaa75632821e5ef41b0db6f58af82edf9b115b01523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04be74b836b4249fb5000aaa75632821e5ef41b0db6f58af82edf9b115b01523"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e5afb2347109f0d52b4814edf5b3d4f2161650492886e8779eae33ad12bf3ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99c9754455abcbebd98d2a1cfbc4edec3e32ceadfdd0f01ea0eb0d349e32c932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deb3b563cc09846dcb13e44b0ad246d2294550e58e9116390f45003a28dd3965"
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
