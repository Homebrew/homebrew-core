class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.15.4.tar.gz"
  sha256 "6f47a80c73aeb97464884e91fef24168317585d2c7a05077567128d0533591e1"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dafe12cffc71e22ff3120889ea0061f6a96768a43f7857abcbd155530a154bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f377dcd850751174258a1b239c94e8f118d35193d099799240558efb8b53ed51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6bfdd50520a6e1991c94155ea4b578d86fd9148bb47d23419362daa3329c421"
    sha256 cellar: :any_skip_relocation, sonoma:        "95ebdf84b6cd207242e269f5f6c8438a5774da5741713719600866e9bdfa3661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91048e83532c626a68bed5b6f9440d9e0abed5830d3986e7c666bbc3b75949a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d5a9197e647d5922a3dc8c16804bf07620fc231b59c28ae5e480b839470c30"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
