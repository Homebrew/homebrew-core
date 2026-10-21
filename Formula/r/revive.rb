class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.17.1",
      revision: "a13d6ab1804751f8f4f964fb1154d057fc9c9ff6"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8904d4423c264c19996af00d262ca04615eca6c78c0979403970ac08f47569fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8904d4423c264c19996af00d262ca04615eca6c78c0979403970ac08f47569fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8904d4423c264c19996af00d262ca04615eca6c78c0979403970ac08f47569fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71f750c4ab2b86ffeac2ac1031ec98c17f0e190caea58f7579a9eca1a3a0f552"
    sha256 cellar: :any,                 x86_64_linux:      "185e99ac86bd12caa23c951e5075264db36e35efe01aaa75c528a63642646038"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
