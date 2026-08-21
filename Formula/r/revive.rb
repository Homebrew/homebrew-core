class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.16.0",
      revision: "b9bc17af86830bdb3a254d97b8f92c8035d0583a"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6aa056baaa4a5c4d4e0007e5ed6f98cb381e87d3a2b97b38a88803eeb0ef109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6aa056baaa4a5c4d4e0007e5ed6f98cb381e87d3a2b97b38a88803eeb0ef109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6aa056baaa4a5c4d4e0007e5ed6f98cb381e87d3a2b97b38a88803eeb0ef109"
    sha256 cellar: :any_skip_relocation, sonoma:        "4604143e67846621f64e380c47f13ca5819f1f95fb412b4a40f5772e95a2e422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8494d7c4a43001cbbcac4fffbdc712efccfb4c8ede8ec6a59f63a92631f8fd12"
    sha256 cellar: :any,                 x86_64_linux:  "71a94f6ff64c3e900e305ba941b90d2bcc61a3f35641e9eea430183b828bc5f2"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -X github.com/mgechev/revive/cli.commit=#{Utils.git_head}
      -X github.com/mgechev/revive/cli.date=#{time.iso8601}
      -X github.com/mgechev/revive/cli.builtBy=#{tap.user}
    ]
    ldflags << "-X github.com/mgechev/revive/cli.version=#{version}" if build.stable?

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/revive -version")

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    GO

    system "go", "mod", "init", "brewtest"
    output = shell_output("#{bin}/revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
