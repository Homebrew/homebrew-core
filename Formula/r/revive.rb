class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.10.0",
      revision: "6becd540e4f864330381c0f2cd0cf05089aa8aa3"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b87e2cf8bd14cbbf031657dfa3b999f9bb3abcd315837b29ddf4e0047eeb4eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b87e2cf8bd14cbbf031657dfa3b999f9bb3abcd315837b29ddf4e0047eeb4eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b87e2cf8bd14cbbf031657dfa3b999f9bb3abcd315837b29ddf4e0047eeb4eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "026da2b8efbd5bc1d56544af835be71c3228b6c2acf758ee60bd3c28b382640c"
    sha256 cellar: :any_skip_relocation, ventura:       "026da2b8efbd5bc1d56544af835be71c3228b6c2acf758ee60bd3c28b382640c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d8d82c52605978c9e8a4142062f492891eaeec31c5fffa12a5ab97b95c8e323"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/mgechev/revive/cli.commit=#{Utils.git_head}
      -X github.com/mgechev/revive/cli.date=#{time.iso8601}
      -X github.com/mgechev/revive/cli.builtBy=#{tap.user}
    ]
    ldflags << "-X github.com/mgechev/revive/cli.version=#{version}" unless build.head?

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
