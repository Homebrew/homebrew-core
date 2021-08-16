class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.1.0",
      revision: "c582d6221fe731ac65470a27a89af16131b34478"
  license "MIT"
  head "https://github.com/mgechev/revive.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ddeb4ed2f5b67ed0d198b73818f07af3c3a1fd0923940cfaf9c8b6ba63635c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a8ae58af838fb60f08b508d21f8fdfff4404ca941dbfd91b32130b8edad3f25"
    sha256 cellar: :any_skip_relocation, catalina:      "b8f15e2ef521f2ecd10e9f487280b79959f7f420f728355edc146ebc752aeb1b"
    sha256 cellar: :any_skip_relocation, mojave:        "b7d404bf410778c306d6a0ab036da2a46e3b0723ee400af5350e9cd73750e57d"
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
