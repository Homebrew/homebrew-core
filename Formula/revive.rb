class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.1.2",
      revision: "111721be475b73b5a2304dd01ccbcab587357fca"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e7723cd331d40585626728d683433b3ef8260bf9fe1b45360a010fce8eee136"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dd6420a0f09eb9d82821c76be285ce7f607ee67f9b769f8d2d5e6a6a4fb2367"
    sha256 cellar: :any_skip_relocation, monterey:       "fefba617040e19ca4e40a46449c53a2e6a51c8456c9428042bc0d3522cbfab7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb2c909f8240e9139f2bf99b5817db422a64e85703c23d355f99c01106ba110d"
    sha256 cellar: :any_skip_relocation, catalina:       "cb2c909f8240e9139f2bf99b5817db422a64e85703c23d355f99c01106ba110d"
    sha256 cellar: :any_skip_relocation, mojave:         "cb2c909f8240e9139f2bf99b5817db422a64e85703c23d355f99c01106ba110d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "752f0f64a9ee4157ecba309e80d8e85abe29bb3f3684ae9ebfadef58399e23eb"
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
