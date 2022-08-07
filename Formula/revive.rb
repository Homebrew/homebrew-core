class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.2.3",
      revision: "556d4852f934a726fae0e8cb3d1dcdaef8bf2440"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215ae4622ec59ea8a9386bdb60bef437b2601b242c54abc8e83479165130eb87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "215ae4622ec59ea8a9386bdb60bef437b2601b242c54abc8e83479165130eb87"
    sha256 cellar: :any_skip_relocation, monterey:       "bf4b2cc72ea1355a1eedd95d252a7ea15812735a4b20745e70a32f322eaf0806"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf4b2cc72ea1355a1eedd95d252a7ea15812735a4b20745e70a32f322eaf0806"
    sha256 cellar: :any_skip_relocation, catalina:       "bf4b2cc72ea1355a1eedd95d252a7ea15812735a4b20745e70a32f322eaf0806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe726019996c9d660d1cd2afd6661f81eb7a08a7d12e07c44cd8230a4642596d"
  end

  depends_on "go" => :build

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
    output = shell_output("#{bin}/revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
