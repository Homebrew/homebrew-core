class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.6.0",
      revision: "d9c61c1518f16418ad94d92b2d5976c266e0ad6e"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76aedee694602eb8ce7c49da56434faf645bbd4372110dd1a3ab5d5f3731f90f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76aedee694602eb8ce7c49da56434faf645bbd4372110dd1a3ab5d5f3731f90f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76aedee694602eb8ce7c49da56434faf645bbd4372110dd1a3ab5d5f3731f90f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdee64fe8a8255f4bcd997d8d794ad2008cfd731493d19db81bee45409d9197c"
    sha256 cellar: :any_skip_relocation, ventura:       "cdee64fe8a8255f4bcd997d8d794ad2008cfd731493d19db81bee45409d9197c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd1cdd13ca95cc045e554530ff958fea29235e3e6cdc03ab3e0baf389618c9d2"
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
