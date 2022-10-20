class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.2.4",
      revision: "3116818e5957e649afda1e2762c4b0bb1fa9736c"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ef0d85f18b2c2f3f0aaaa1c8fd8a42e1e439a374c5c95e053da8855959dd6f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef0d85f18b2c2f3f0aaaa1c8fd8a42e1e439a374c5c95e053da8855959dd6f7"
    sha256 cellar: :any_skip_relocation, monterey:       "612dfe2fe091807adffd88081a60f8b5b095a5f399037c8cb7d81e6ea0b4a6e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "612dfe2fe091807adffd88081a60f8b5b095a5f399037c8cb7d81e6ea0b4a6e8"
    sha256 cellar: :any_skip_relocation, catalina:       "612dfe2fe091807adffd88081a60f8b5b095a5f399037c8cb7d81e6ea0b4a6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f41b622dc48aaa8bb418d9e125e864ac5ea47de7fa223ec3cd74ee825206ac8"
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
