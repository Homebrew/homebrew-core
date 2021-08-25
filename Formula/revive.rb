class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.1.0",
      revision: "c582d6221fe731ac65470a27a89af16131b34478"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00e1f390c9e6013aab8c9b747d4a7228a7db4730616b96bba75c824d521c4d78"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa55ea61533db719fe0800ded1f63d570db5ace7e86382def43235efd32c0afb"
    sha256 cellar: :any_skip_relocation, catalina:      "fa55ea61533db719fe0800ded1f63d570db5ace7e86382def43235efd32c0afb"
    sha256 cellar: :any_skip_relocation, mojave:        "fa55ea61533db719fe0800ded1f63d570db5ace7e86382def43235efd32c0afb"
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
