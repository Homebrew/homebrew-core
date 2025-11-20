class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.1.tar.gz"
  sha256 "aa5705ed56f74651ad8cbeabc8fa402a93be8d2845bacd26e16159ca440c6942"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d3adb661ce491cd1430f4eacfb2b8188d34848fdff9830e31f546403fa2cf31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a572b7186f2705f4c024d7e637ecdae303fc804dbe77705944fcc4ab61325503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88bcfa84d342e15600447680790b89a424f74ad0a4fd8cfd56ccfc5a6d76557"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe917bea23ab42821e2b8cbaaa0138b7eb70dbd43af7f29a2446fadde5cae219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3717eaf1b00594eeb9af75e261eb1aa0964f96eb053576a90a397c76cebfd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ec0fbc520f68c01538c0953fb425bcacc9eb2e73436384b15ca79d93efe467"
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
