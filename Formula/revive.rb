class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.1.1",
      revision: "18cdb55850ae667e1136cf5c2749fab98a911c5b"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b10428f433328747a6c4610eba3c4bfb1da8d38235e3a14a1b6d9d1cd4c1561e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e9d926d7fc9c92b811f086ea632b69f654007de10253dea6f9f00b943f53468"
    sha256 cellar: :any_skip_relocation, catalina:      "3e9d926d7fc9c92b811f086ea632b69f654007de10253dea6f9f00b943f53468"
    sha256 cellar: :any_skip_relocation, mojave:        "3e9d926d7fc9c92b811f086ea632b69f654007de10253dea6f9f00b943f53468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5656421dd1b71c7a00807ee276ea22df8537ad50e9e8437626c170d006a1f540"
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
