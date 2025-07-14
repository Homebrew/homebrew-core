class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.14.3.tar.gz"
  sha256 "e6ec34b60e4d4892d7f22895a04905c7bead2477f05d39c0f3bb674faf4815f9"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbc73fc73c5d73c977f6f4ca2c93a3feb48037e159930a08a107dfdff45a0b3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbc73fc73c5d73c977f6f4ca2c93a3feb48037e159930a08a107dfdff45a0b3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbc73fc73c5d73c977f6f4ca2c93a3feb48037e159930a08a107dfdff45a0b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd385b3898ae77125177e6ff2aefae8011d6118679eb11b725622356ee9e1443"
    sha256 cellar: :any_skip_relocation, ventura:       "dd385b3898ae77125177e6ff2aefae8011d6118679eb11b725622356ee9e1443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93583b5f7d5b3f29ba7502d2d89e6d538cd8d28e20d10822392dcf0e174b0650"
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
