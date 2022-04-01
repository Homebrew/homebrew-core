class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2022.1.tar.gz"
  sha256 "aecfced0299fc70d17fc7d8d8dc87590429081250f03cb4c6bdd378fd50353ab"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713b2331e3491b90fded2129d8c8e3e0aece85fa17a294e32276d227ac7c06d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33371bac06520a5c72772dae5ee442fc070946d0a9559d7372584dcebe6f7818"
    sha256 cellar: :any_skip_relocation, monterey:       "589194bc56d52e1c2d4a069ef1d953b6101644079a5eb55bb1cd8be427173f95"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4928baae580c74e51a8917207f6a717b6704bf678374971463dc9f9e24fb2c5"
    sha256 cellar: :any_skip_relocation, catalina:       "bbc1d022792158774f07554e1705ebb2be414665813be279884e1a2efe34cee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c101d6ba2c26032cc51cabb2ab1ea67f7513cce233f8925f4c8c483742a55d17"
  end

  # Bump to 1.18 on the next release.
  depends_on "go@1.17"

  def install
    output = libexec/"bin/staticcheck"
    system "go", "build", *std_go_args(output: output), "./cmd/staticcheck"
    (bin/"staticcheck").write_env_script(output, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
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
