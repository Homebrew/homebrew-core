class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.3.9",
      revision: "9ec5e553e9be5cbf9efd3950d789dbd767137ea0"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f094f3ccdc74d750af557363cd4e32cd1563dbde935179b167282db77a77805a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45a6133d45061003ca098e365c9a8ab57a9e1da110f4a15c2d3b2f58646c7aa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86eb97c91bed57ed9d857f89a43e2669ae5158413f300d327034689fbc8272b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbe32aa80c6159a8a8610e68a412ee708729a61895414e2ace7bbdfe5dc90df6"
    sha256 cellar: :any_skip_relocation, ventura:        "96f1c0f5715e1c78aecb45139f9891539e1790233587f0aa39a73a869653ff8b"
    sha256 cellar: :any_skip_relocation, monterey:       "ca01b0fdd0e1e8c75e774cb3cd36db0aee66318140ea8d720ad76397469208c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b92bf8957ed88c6895c67ab10a4c4e42f35366c690e18ff499085446af1f2be1"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    ldflags << "-X main.version=#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    EOS

    system "go", "mod", "init", "brewtest"
    output = shell_output("#{bin}/revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
