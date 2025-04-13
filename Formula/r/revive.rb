class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.9.0",
      revision: "57ed899d0ce6ab78ad51cb83e67d2d9d32873eb2"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b485fda87a88873ce360319b32fcbcbd01a43251eaeeb0b86ed1df642d72241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b485fda87a88873ce360319b32fcbcbd01a43251eaeeb0b86ed1df642d72241"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b485fda87a88873ce360319b32fcbcbd01a43251eaeeb0b86ed1df642d72241"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a36bd94a2f69bdda551658a833939d562b359287756f035e946fcf9d15f65a9"
    sha256 cellar: :any_skip_relocation, ventura:       "7a36bd94a2f69bdda551658a833939d562b359287756f035e946fcf9d15f65a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2be28421f2fbf5de6bfef7f6178838d19fc728a43e3521ad6f5899d7dcf8d629"
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
