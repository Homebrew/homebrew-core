class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "4361c19d70bb2bb7b53bca7e2151843ecc35dcc98b931471b86cb18687ebbd1d"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fba864efc005303b27da0b384124fba3b998d5333eac3effadba670dc00ee064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba864efc005303b27da0b384124fba3b998d5333eac3effadba670dc00ee064"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fba864efc005303b27da0b384124fba3b998d5333eac3effadba670dc00ee064"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fbc17c4ed46ac150160e1364c5a8fb139b22ef38cd58526b4e729f4a933c53d"
    sha256 cellar: :any_skip_relocation, ventura:       "7fbc17c4ed46ac150160e1364c5a8fb139b22ef38cd58526b4e729f4a933c53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22021e7a1150712ec3db9483c4eec179d988e444fc06c6b3482df65b7a52bddd"
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
