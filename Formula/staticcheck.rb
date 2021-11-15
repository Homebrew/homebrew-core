class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2021.1.2.tar.gz"
  sha256 "c3fcadc203e20bc029abc9fc1d97b789de4e90dd8164e45489ec52f401a2bfd0"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41e6e3473bd15b06b75ad1fd049bef8c7bca258711ff65ec414782b3722c6771"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b34b0c7309db3d0db7737fed9f35d8ecda98ec859052de88640ebdb41eee1e40"
    sha256 cellar: :any_skip_relocation, monterey:       "8c0ab2d42effed26f0333bdc5b4038c59aad5bcab6ab4540bd66190f13983fca"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa8b3b37a7aee60548db46f8ff92964669818d2b15d1f58c876fe4b04f760a8b"
    sha256 cellar: :any_skip_relocation, catalina:       "f205694945b93cbf98079bfd277338026b3c31956638e0342b056ec743e4ebce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddc97876035c049806118c39f1033f2217675e72331131ba0153351177d73527"
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
