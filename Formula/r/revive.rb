class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.3.3",
      revision: "9a87e6fd820317b1235e1b75bc884ce34c375dd5"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a81b8ab9b79fb53bf674a4ab89c7d1d5ebda34e69152cd0fd5f3657b956e489"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a81b8ab9b79fb53bf674a4ab89c7d1d5ebda34e69152cd0fd5f3657b956e489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a81b8ab9b79fb53bf674a4ab89c7d1d5ebda34e69152cd0fd5f3657b956e489"
    sha256 cellar: :any_skip_relocation, ventura:        "ab722b7035e02b08d0f1995bb9032785e6804fa9e122012dbe2402028fbb6975"
    sha256 cellar: :any_skip_relocation, monterey:       "ab722b7035e02b08d0f1995bb9032785e6804fa9e122012dbe2402028fbb6975"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab722b7035e02b08d0f1995bb9032785e6804fa9e122012dbe2402028fbb6975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce3ef89ee971b161fde6603a160299824143586c20c0e05fd73fe00eb3b18c4"
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
