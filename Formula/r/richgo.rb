class Richgo < Formula
  desc "Enrich `go test` outputs with text decorations"
  homepage "https://github.com/kyoh86/richgo"
  url "https://github.com/kyoh86/richgo/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "811db92c36818be053fa3950d40f8cca13912b8a4a9f54b82a63e2f112d2c4fe"
  license "MIT"
  head "https://github.com/kyoh86/richgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c1bb646af1a17b66efb00c745ee6d27b14d9a5e492af3bf822e3867c7e2fde7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c1bb646af1a17b66efb00c745ee6d27b14d9a5e492af3bf822e3867c7e2fde7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c1bb646af1a17b66efb00c745ee6d27b14d9a5e492af3bf822e3867c7e2fde7"
    sha256 cellar: :any_skip_relocation, sonoma:         "49fe050b51a058b64c0807e93830cb7ae9ea18ce86483fa1893c9e5aee8a15c1"
    sha256 cellar: :any_skip_relocation, ventura:        "49fe050b51a058b64c0807e93830cb7ae9ea18ce86483fa1893c9e5aee8a15c1"
    sha256 cellar: :any_skip_relocation, monterey:       "49fe050b51a058b64c0807e93830cb7ae9ea18ce86483fa1893c9e5aee8a15c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "064fa2fd7163441e7bf38121a82c8e87f2d7b5123a6c2a6c33c2361d685e5b75"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module github.com/Homebrew/brew-test

      go 1.21
    EOS

    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func Hello() string {
        return "Hello, gotestsum."
      }

      func main() {
        fmt.Println(Hello())
      }
    EOS

    (testpath/"main_test.go").write <<~EOS
      package main

      import "testing"

      func TestHello(t *testing.T) {
        got := Hello()
        want := "Hello, gotestsum."
        if got != want {
          t.Errorf("got %q, want %q", got, want)
        }
      }
    EOS

    output = shell_output("#{bin}/richgo test ./...")

    expected = if OS.mac?
      "PASS | github.com/Homebrew/brew-test"
    else
      "ok  \tgithub.com/Homebrew/brew-test"
    end
    assert_match expected, output
  end
end
