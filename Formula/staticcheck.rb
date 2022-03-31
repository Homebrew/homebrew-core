class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2022.1.tar.gz"
  sha256 "aecfced0299fc70d17fc7d8d8dc87590429081250f03cb4c6bdd378fd50353ab"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae46d9d823020102a04bbd7105d1464706c11dc5d9a38fffad8a1ee5139bd82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc402285ad915ab298629a6cf36cb7665f4f06b6930abfd3a397b05ce9243e7b"
    sha256 cellar: :any_skip_relocation, monterey:       "f84807e06de699c7d59d496448cd22b26b408ad3eca0d28b3d0ffb1bbc84957e"
    sha256 cellar: :any_skip_relocation, big_sur:        "15af4a9bef8104f871fd4ac6c2e98e56326ba9a791642f0431984bb49b423d42"
    sha256 cellar: :any_skip_relocation, catalina:       "53f88a9880924137a2eca5d6ea2a0281e40c56601716e2ec522ad5e699cf2c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251f993f13ee9988c0e074b087fefa03eb83a9a4a58c74473cb8420bdff7af9f"
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
