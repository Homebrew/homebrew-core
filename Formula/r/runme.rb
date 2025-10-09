class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.15.4.tar.gz"
  sha256 "6f47a80c73aeb97464884e91fef24168317585d2c7a05077567128d0533591e1"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcb9618c58552486aa89490a4eb63e9c0e4c931d56bd1cc84fa65deedbf773a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22d600f328e20fac3b5f30f24921711a9eed4b3e88da1f5f4fe5ae436e13931e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b550bb2eb45f608b79c63b6ad2c56b5188c18050492f5fcc44a9fffa2e7c6b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1b67a5d8b29078e29764f46bd01e0e240f1948310b8bce315d231f065bf8821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81c1eef1d3302f2dcd9a6b4ee0c31c00062bb14240484688e49dbbf2980b7b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa4e11f76a821165f9239992054ee4806de84c00a6a228970188eb4491ee5e56"
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
