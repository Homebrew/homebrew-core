class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2022.1.2.tar.gz"
  sha256 "807a3b3e5375c3b3b591567dc49e1e1f014498681bb89d6508ef2cc3a76307ab"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38d74621b53ded5b915f21ef62152215759027116f06bafec98811bf7ebe66c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58205509e1542d817cc58904ec5a9d31d5677d7e6380d454cb51d5b9177979b3"
    sha256 cellar: :any_skip_relocation, monterey:       "4a5d9af86316c34004576b74a0e00e1fbf067cc86738ee6ff70b4f9dc70ba05f"
    sha256 cellar: :any_skip_relocation, big_sur:        "deb46a2f6e77c78e9da39888efec116d6875c93b4341b0827fbdf0cabf7963fa"
    sha256 cellar: :any_skip_relocation, catalina:       "4c7e30316982c82cc30bcaeef391d0e2b5da706eb29b95a730e162ed59e3b68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e92149a6b5592da3f05539bb972121e9b8ab41eb4f0bf1284783ba83bf227eb"
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
