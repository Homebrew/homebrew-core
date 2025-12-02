class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.13.0",
      revision: "ac5f398440705ae79abf836674f46c24a2494949"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6c07d75d105c7294993c08c12277ee54a90a866d7b4c13993729a0341f4c5ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6c07d75d105c7294993c08c12277ee54a90a866d7b4c13993729a0341f4c5ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c07d75d105c7294993c08c12277ee54a90a866d7b4c13993729a0341f4c5ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0c69c44367f6e1ed525cd22c4d15bac14494cf4a13b5d49685ecb94897d1a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1a318a9cb623e0657bd5e63560f7c83a6791e53ce0c7cba3741a8b63b249dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd368980de74dd01a1aaa3b18a598a29225efead9fa3ac0c4076337eec0f296e"
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
