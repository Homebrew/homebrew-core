class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.14.0",
      revision: "b38af67f543f0ffa51522ae967130b428c04543c"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20f2c3c3a3b23bb541fe76bfcd89d79d8fbbcf1793dc4254e0471bbaf8a8702a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20f2c3c3a3b23bb541fe76bfcd89d79d8fbbcf1793dc4254e0471bbaf8a8702a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20f2c3c3a3b23bb541fe76bfcd89d79d8fbbcf1793dc4254e0471bbaf8a8702a"
    sha256 cellar: :any_skip_relocation, sonoma:        "10efbe24be573b52370408c68492597c1aa96b20df6c68fcf3008f3e2135bf12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b601fe2e94b97a629aeea8d98620eb71ce22de794b2ee7b63f70339c69edc0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f3d5a48535b83278cbe54c474b5a1531e531c070e742fb33f26fb28d1cf9687"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
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
