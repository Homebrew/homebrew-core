class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.0.9",
      revision: "89f108c22aa9ccc72f190c8622578e52ee615361"
  license "MIT"
  head "https://github.com/mgechev/revive.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa43affe200290ca06eb715c288b493638a77cf04b932743f4508136d921d446"
    sha256 cellar: :any_skip_relocation, big_sur:       "988d57398c94172b3d69cd3210c7ad8144946a643c0d540ee23ba377db6ecac1"
    sha256 cellar: :any_skip_relocation, catalina:      "d9d3c57b4b8151253042abce2f15bcee73a0468962f8c813922bd50298701da5"
    sha256 cellar: :any_skip_relocation, mojave:        "a305035aabd26548d25f98ca8583b43f5a1afea9db0d03d1527e248e8232a9bb"
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
