class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.1.4",
      revision: "d4fbc9244093baaa4cdbcc310fde154a01dfc172"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87313e42a472abcdd943b266ee2e5aedb0e35190ec02691c91d98d07c6bf8e80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87313e42a472abcdd943b266ee2e5aedb0e35190ec02691c91d98d07c6bf8e80"
    sha256 cellar: :any_skip_relocation, monterey:       "ab579952fb9f57161996b3e2e82cee54d15c3939d46cd97c8c2c60ea20edffb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab579952fb9f57161996b3e2e82cee54d15c3939d46cd97c8c2c60ea20edffb6"
    sha256 cellar: :any_skip_relocation, catalina:       "ab579952fb9f57161996b3e2e82cee54d15c3939d46cd97c8c2c60ea20edffb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3892ad1ad91059c5e5ded18f53d1bb963eb752ce24c83903e1f8b2a8979c18e3"
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
