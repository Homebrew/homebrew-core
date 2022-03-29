class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.2.0",
      revision: "671c55d82e238932de6e461df7bbc8b763719750"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44e25ab98c22c8984d211a45109b05869724ec8db661373c9ad797732b876243"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44e25ab98c22c8984d211a45109b05869724ec8db661373c9ad797732b876243"
    sha256 cellar: :any_skip_relocation, monterey:       "061e8b155d55c20008d5aeb941d5f3cf62545366fa4107bf7a4d320a192386f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "061e8b155d55c20008d5aeb941d5f3cf62545366fa4107bf7a4d320a192386f5"
    sha256 cellar: :any_skip_relocation, catalina:       "061e8b155d55c20008d5aeb941d5f3cf62545366fa4107bf7a4d320a192386f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc9cbb36397b518dc7f84223eaad078f5819c5063be9d21692080a47315b7570"
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
