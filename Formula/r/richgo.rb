class Richgo < Formula
  desc "Enrich `go test` outputs with text decorations"
  homepage "https://github.com/kyoh86/richgo"
  url "https://github.com/kyoh86/richgo/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "811db92c36818be053fa3950d40f8cca13912b8a4a9f54b82a63e2f112d2c4fe"
  license "MIT"
  head "https://github.com/kyoh86/richgo.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f1b78098f87488a5c1b495ff94ce40d6734d11a6db077b03356fe7d281cccbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967353f6b2bfa1c35a96f76eb85b98d3e6ea91d8b424a2655e80ab957884591b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "967353f6b2bfa1c35a96f76eb85b98d3e6ea91d8b424a2655e80ab957884591b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "967353f6b2bfa1c35a96f76eb85b98d3e6ea91d8b424a2655e80ab957884591b"
    sha256 cellar: :any_skip_relocation, sonoma:        "31d3f488ac0adb8874295408a1ea9c56acfbf9a90484d90b3e34d76ffcf20927"
    sha256 cellar: :any_skip_relocation, ventura:       "31d3f488ac0adb8874295408a1ea9c56acfbf9a90484d90b3e34d76ffcf20927"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1fc560cd4dc811280afea8b811f126da120bb2546af32f601131837feb41e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da63b93248cf2292a4c287cc5973c39eded1d3c349ebfba315b3913883045d3c"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module github.com/Homebrew/brew-test

      go 1.21
    GOMOD

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func Hello() string {
        return "Hello, gotestsum."
      }

      func main() {
        fmt.Println(Hello())
      }
    GO

    (testpath/"main_test.go").write <<~GO
      package main

      import "testing"

      func TestHello(t *testing.T) {
        got := Hello()
        want := "Hello, gotestsum."
        if got != want {
          t.Errorf("got %q, want %q", got, want)
        }
      }
    GO

    output = shell_output("#{bin}/richgo test ./...")

    expected = if OS.mac?
      "PASS | github.com/Homebrew/brew-test"
    else
      "ok  \tgithub.com/Homebrew/brew-test"
    end
    assert_match expected, output
  end
end
