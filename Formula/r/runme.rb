class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "fe784084ecd7efa23853f36c39331b92d90c9353cc831433502712d4ab41ea6b"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c77bc1b77c517aaf11d7fa7398f7a07a5cf6f76dd9eb861a4fd6599a30a6d94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbd0df3420ea2c5311ff9eacc50fffe641f20ab4085b225d8689b7bf793e7383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d385445a9c148b2f01d1f018c6b5052ab9ff9c416f43d5ba4da81438512a24"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cceb252182ccac8addc9208865b7dced6a8e00344ac52133e28bfafa07bd734"
    sha256 cellar: :any_skip_relocation, ventura:        "d247df01ee6b45cafc94e2acacbacd1137fff758409df25eb28bbcb9bc67419c"
    sha256 cellar: :any_skip_relocation, monterey:       "b7fc15e533f1f71a368c4a40d20912c76a842b29a2b96da937fe2f38dba805eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473ffea3da848f73aba9f7243357f8e40c4034c9112edcd6e9a6392955ba1b2b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system bin/"runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
