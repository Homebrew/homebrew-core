class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "24d88f4c6eafe4b36893e06ea9395351a2363df88571c79f8b816698c57ef74e"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc0752ae0c5865acded0003fd1bb786e174b0ff5cee7a064b8c5253c9d6621d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc0752ae0c5865acded0003fd1bb786e174b0ff5cee7a064b8c5253c9d6621d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc0752ae0c5865acded0003fd1bb786e174b0ff5cee7a064b8c5253c9d6621d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0d7fd8e160e417eb50de94060c536737aa187b7fbdf83b854b3c7a88e662544"
    sha256 cellar: :any_skip_relocation, ventura:       "b0d7fd8e160e417eb50de94060c536737aa187b7fbdf83b854b3c7a88e662544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0276b00ae5741544db5f8c2baa648ec8f803d39c3ee9a9ac53014ffb79c295be"
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
