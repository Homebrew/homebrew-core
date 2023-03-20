class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.3.1",
      revision: "b03e54f617491984b41f0411b69326f94d03a76f"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7da60f366374cc99e376e2233773c6d8fbf6d56df0dd7feb56e2b1433e7bdac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7da60f366374cc99e376e2233773c6d8fbf6d56df0dd7feb56e2b1433e7bdac9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7da60f366374cc99e376e2233773c6d8fbf6d56df0dd7feb56e2b1433e7bdac9"
    sha256 cellar: :any_skip_relocation, ventura:        "22c5e03b9635a1826c9372d4d2c14a86e06fbb4a6f50637af974abf5525211cf"
    sha256 cellar: :any_skip_relocation, monterey:       "22c5e03b9635a1826c9372d4d2c14a86e06fbb4a6f50637af974abf5525211cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "22c5e03b9635a1826c9372d4d2c14a86e06fbb4a6f50637af974abf5525211cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "decb2e90caa79b24e1a6c961d8a7fc2505342f766e199baa41b6cf0be7790490"
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
