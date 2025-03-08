class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.12.5.tar.gz"
  sha256 "93045f40d5ce3c81a8d5a9b2e3131499f7ac73c45b5668dd335224df98cf8ae3"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "293fb5669882a99c992ff5677687b5bb5d42ba50c38ec8c6c272674387143fcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "293fb5669882a99c992ff5677687b5bb5d42ba50c38ec8c6c272674387143fcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "293fb5669882a99c992ff5677687b5bb5d42ba50c38ec8c6c272674387143fcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc3b7c70b50a1768e61a83155ea2318269ef6ca82f375091421876c85d76781f"
    sha256 cellar: :any_skip_relocation, ventura:       "bc3b7c70b50a1768e61a83155ea2318269ef6ca82f375091421876c85d76781f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f5d53e08b62d0faf26c1f18e7197b1db53d7c60705911bd867ab4defb78025"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system bin/"runme", "--version"
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
