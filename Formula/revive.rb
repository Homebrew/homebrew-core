class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.2.1",
      revision: "23828cc39d4f91b69247bdea0ab4903bd6c1912e"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cdb14e6af9f9f7f78315711f6d4185d7a4beaf9310f7cc2250a9ba693aea384"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cdb14e6af9f9f7f78315711f6d4185d7a4beaf9310f7cc2250a9ba693aea384"
    sha256 cellar: :any_skip_relocation, monterey:       "5450d5524e8838886536e0ade87db29e06ffebc5ca19c57a4020230b311b06eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "5450d5524e8838886536e0ade87db29e06ffebc5ca19c57a4020230b311b06eb"
    sha256 cellar: :any_skip_relocation, catalina:       "5450d5524e8838886536e0ade87db29e06ffebc5ca19c57a4020230b311b06eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d415242a47a6db059d03b6bb14af33e9725694f36a19de861b211f2df1eaec9"
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
