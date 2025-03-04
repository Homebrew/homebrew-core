class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2025.1.tar.gz"
  sha256 "314e7858de2bc35f7c8ded8537cecf323baf944e657d7075c0d70af9bb3e6d47"
  license "MIT"
  revision 2
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96473206ee1357a156f8ec9cede903971593cd2f1fb227c093c045fe71effb68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96473206ee1357a156f8ec9cede903971593cd2f1fb227c093c045fe71effb68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96473206ee1357a156f8ec9cede903971593cd2f1fb227c093c045fe71effb68"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4e947d6bc5ecdc56b373be2c81a1bf0277a273c97e19e882c132c491c17a950"
    sha256 cellar: :any_skip_relocation, ventura:       "a4e947d6bc5ecdc56b373be2c81a1bf0277a273c97e19e882c132c491c17a950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0affc401b566452f7b98a2a0ab3af8521e822931c288ed85a098bbb5b121abe4"
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
