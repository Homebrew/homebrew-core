class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.3.0",
      revision: "5db07b5c971648c8c59d0c84d176e94f11dfbcec"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "330be52bc1318bed0487581d880237613710cda3856a3baa033ff671dfd6806f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "330be52bc1318bed0487581d880237613710cda3856a3baa033ff671dfd6806f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "330be52bc1318bed0487581d880237613710cda3856a3baa033ff671dfd6806f"
    sha256 cellar: :any_skip_relocation, ventura:        "d9f552820ad1b8fa688bd2973baef194ec105c33cfa4bde3ff90a3172f83eedb"
    sha256 cellar: :any_skip_relocation, monterey:       "d9f552820ad1b8fa688bd2973baef194ec105c33cfa4bde3ff90a3172f83eedb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9f552820ad1b8fa688bd2973baef194ec105c33cfa4bde3ff90a3172f83eedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea5593ac6f1d2fc7633bda6c50504040e02e0f9924bbce181e7a741f8715533"
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
