class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.1.tar.gz"
  sha256 "259aaf528e4d98e7d3652e283e8551cfdb98cd033a7c01003cd377c2444dd6de"
  license "MIT"
  revision 2
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa358b34210b2a62d257ebe2e788f197cd55656c18acf72c8f783208ef7353aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa358b34210b2a62d257ebe2e788f197cd55656c18acf72c8f783208ef7353aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa358b34210b2a62d257ebe2e788f197cd55656c18acf72c8f783208ef7353aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "c22f781e614f17c4836a4a3df8a2744fb764a2bc49efa3530e01d8f46ba87453"
    sha256 cellar: :any_skip_relocation, ventura:       "c22f781e614f17c4836a4a3df8a2744fb764a2bc49efa3530e01d8f46ba87453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd84b6cdd36306e9403869f94850b25b5a05561fe2740dbba895115ad06974a"
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
