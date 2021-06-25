class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.0.8",
      revision: "1d91f74b14e68539aacf14dee98900f9f7ccfd58"
  license "MIT"
  head "https://github.com/mgechev/revive.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7470c45d28f504e31687ee0549cf4774d1cb430ef3d45714b74991029ed9595c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ceba55c3db9f94434837c58fc68d64d259de0923bc7950e8ec7894ca29339dcd"
    sha256 cellar: :any_skip_relocation, catalina:      "038b084e928abb635b08a776e73b8bd198027194c450a03b54bd786f7ee84674"
    sha256 cellar: :any_skip_relocation, mojave:        "f02d8da6764f5592fc788fc3fc2b4b77b243fdc27b124e018aa41f2aaf6fe74d"
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
