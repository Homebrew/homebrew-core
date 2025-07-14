class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.11.0",
      revision: "92243279ea475f93e3bfa468488f5b44c642a659"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01cf0c24e5b50dbe6f99f116d16daac4ae1f7d949245adff9250f2541d6e10f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01cf0c24e5b50dbe6f99f116d16daac4ae1f7d949245adff9250f2541d6e10f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01cf0c24e5b50dbe6f99f116d16daac4ae1f7d949245adff9250f2541d6e10f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6705dcf52da83c83a3dc85fb8ae2f626f7585d06916bb66a08e3d822c7c923b"
    sha256 cellar: :any_skip_relocation, ventura:       "b6705dcf52da83c83a3dc85fb8ae2f626f7585d06916bb66a08e3d822c7c923b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418e6d583867b8ef673e912ebc44aa7af5d34bde72d19f8d21fde9bfaedc2e82"
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
