class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.2.0",
      revision: "671c55d82e238932de6e461df7bbc8b763719750"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "015c891af98f350b8089b1be3102aaf366e54756b3742523442b9751301906c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "015c891af98f350b8089b1be3102aaf366e54756b3742523442b9751301906c5"
    sha256 cellar: :any_skip_relocation, monterey:       "df67edbf00173390fedc62b497c946e106632f299a28b509c77cee0cc5ea0352"
    sha256 cellar: :any_skip_relocation, big_sur:        "df67edbf00173390fedc62b497c946e106632f299a28b509c77cee0cc5ea0352"
    sha256 cellar: :any_skip_relocation, catalina:       "df67edbf00173390fedc62b497c946e106632f299a28b509c77cee0cc5ea0352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "933f4d88eb3bc72308e5b55d8214c314137b50676a4039b2f6dc149f476cb7dd"
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
