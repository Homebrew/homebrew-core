class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2022.1.2.tar.gz"
  sha256 "807a3b3e5375c3b3b591567dc49e1e1f014498681bb89d6508ef2cc3a76307ab"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0c9327adaead8b33acf9ac31a7543f4881b443fa064acc96b6c034a7bdb764b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec11a5ad26ae2ee8e5d31f2ceafbc96b38c44b0ab63cc6d6375ae01b6c71bb6a"
    sha256 cellar: :any_skip_relocation, monterey:       "98959fc5a4362c9e9bcaa52b6d9012975805a751a40421edd11cc7d14c36db94"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4f53c3b2bf2c2b94ee71c8635eeea9626b87313809f601b0df5f71784daa199"
    sha256 cellar: :any_skip_relocation, catalina:       "b05ed2c4f9a64d1d3c4fe43655188c0e2a5ffd6c3cf1180e2437587664d07b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd69e33fa3c007c141e6a767933c0b086ee51e1a6f073afa022d1cc56eba3c56"
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
