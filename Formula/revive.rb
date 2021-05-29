class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.0.7",
      revision: "c4d52d202d4c4dd7b34899e07899a34b92d62a12"
  license "MIT"
  head "https://github.com/mgechev/revive.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5140eea58dffb9525b63a9d6483e3696662f3f44352fc0555862d23047226e79"
    sha256 cellar: :any_skip_relocation, big_sur:       "936d94d5807f1b3ca1c110ff51347848875cdc83f077f0c14ac50363d526528c"
    sha256 cellar: :any_skip_relocation, catalina:      "3c5a1640c8619108a6775da06575c571f1f935b510e2f762b66ec4e8a7100338"
    sha256 cellar: :any_skip_relocation, mojave:        "f0f79abb069d51418d4ef23f0567ed9ee2c116f3d37d59d5e92eca1c62de94ae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.date=#{Time.now.utc.iso8601}
      -X main.builtBy=Homebrew
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
