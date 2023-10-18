class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.3.4",
      revision: "93219dac49afec56cdacc7e69080add535e7e088"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "728e04384b88fbde733917c69ff26eaf3c83a137f31858232f59001c47d1c666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "728e04384b88fbde733917c69ff26eaf3c83a137f31858232f59001c47d1c666"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "728e04384b88fbde733917c69ff26eaf3c83a137f31858232f59001c47d1c666"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "728e04384b88fbde733917c69ff26eaf3c83a137f31858232f59001c47d1c666"
    sha256 cellar: :any_skip_relocation, sonoma:         "c90c9afd9bdca22eba4f1910d6197edb10b3874102b0f8890a3eb33242ee44a0"
    sha256 cellar: :any_skip_relocation, ventura:        "c90c9afd9bdca22eba4f1910d6197edb10b3874102b0f8890a3eb33242ee44a0"
    sha256 cellar: :any_skip_relocation, monterey:       "c90c9afd9bdca22eba4f1910d6197edb10b3874102b0f8890a3eb33242ee44a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c90c9afd9bdca22eba4f1910d6197edb10b3874102b0f8890a3eb33242ee44a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c993ff603667711c528242533e38a1f2507b8261c14d3c774567ec0a31b221"
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
