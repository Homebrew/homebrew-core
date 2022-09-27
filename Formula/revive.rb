class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.2.4",
      revision: "3116818e5957e649afda1e2762c4b0bb1fa9736c"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caacf9e69acea46d988fd29f773641bc2e3847876fd8a4666721e617e483c4b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caacf9e69acea46d988fd29f773641bc2e3847876fd8a4666721e617e483c4b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ec4ef29a5177ac62a9352db0694c901cf46795f3aa90ca1eed2080ba717a3c90"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec4ef29a5177ac62a9352db0694c901cf46795f3aa90ca1eed2080ba717a3c90"
    sha256 cellar: :any_skip_relocation, catalina:       "ec4ef29a5177ac62a9352db0694c901cf46795f3aa90ca1eed2080ba717a3c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "913db30ec17b1f25668d3577978f998b320a6be9541931b72b16eb9b2d2f5b14"
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
