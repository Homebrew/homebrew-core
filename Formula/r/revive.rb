class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.3.7",
      revision: "5c5d6c1075a82337d9840e7f8195c0eaccdb959c"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed7ad7a119741ae0c6df650dc76826a1a0603ffe4f5369d5e6f3209ca9442020"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9349b8da3657103b79848355b3dac3a3b041df6c48693ae547a63dc3a7c00e6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68eee8bdcdb47e5ff183cd491222e696a29477b6f052e405cb2d7875b7f157d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "86301f225e7d2c3771fa4cdd2434ed8fb3665ebfd4526a764a56907ddc36f101"
    sha256 cellar: :any_skip_relocation, ventura:        "6a38cb97c650c52deff8e9ade90c985659fbc1920134b16c3faeda88bcdcdb7a"
    sha256 cellar: :any_skip_relocation, monterey:       "e82afde38dd0378bb36cc7177535e15fd1ef2bf37a2f706064390559f8865a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0eaf687ce44344266c7681757cba8b28ffe70bdb91ab9f434fde4158b5476c"
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
