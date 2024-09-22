class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.4.0",
      revision: "a65fb8d1b5f6f64665191600873c9289e89e06a4"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4bd9db921ad15d76be08135faef2a851af2b178265ccf1d79d91669547d3255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4bd9db921ad15d76be08135faef2a851af2b178265ccf1d79d91669547d3255"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4bd9db921ad15d76be08135faef2a851af2b178265ccf1d79d91669547d3255"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1827796434ed5ee4f45859eb95fb9fdf23c8914ffb717bfdbb5438e11648f45"
    sha256 cellar: :any_skip_relocation, ventura:       "e1827796434ed5ee4f45859eb95fb9fdf23c8914ffb717bfdbb5438e11648f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1559b0860ed95ff2a0a3f6d79ada2d915031767ad5e6cd8b8f7bc1e1d539b48c"
  end

  depends_on "go" => [:build, :test]

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

    system "go", "mod", "init", "brewtest"
    output = shell_output("#{bin}/revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
