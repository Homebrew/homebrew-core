class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.12.0",
      revision: "e1d05f7a0e941fe7377279012e22b631e6e3df26"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "685691a300458c59b449d1ff6340bebea67bb54c0f099ac82de939b1d216896e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd3bb4a10d8dcb63213bd79d4a320a8e57cfe4ef45281ea533a7b25b7f98d88f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd3bb4a10d8dcb63213bd79d4a320a8e57cfe4ef45281ea533a7b25b7f98d88f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd3bb4a10d8dcb63213bd79d4a320a8e57cfe4ef45281ea533a7b25b7f98d88f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8931abba6f356b772bfbc2901b6fb4a2798170e9d09c3fe457dcfa3062b0b70"
    sha256 cellar: :any_skip_relocation, ventura:       "d8931abba6f356b772bfbc2901b6fb4a2798170e9d09c3fe457dcfa3062b0b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7385ad9d8ca802d6ccafb1563132461295a9aaa0c2d0f6f5661bba419045b08"
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
