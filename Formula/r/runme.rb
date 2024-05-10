class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.8.tar.gz"
  sha256 "e5afa6059d4065a61f4b7f29bd55360fd7da52ed2a95ac5c91ab31b0322d33f4"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a0d1b38b3368958f137371b99f0e7aafc6157aad9a232c2f81dfa69bf743c13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08a503460ac87083e46b440c0f229f2f70e9b75dccc05949877a1969860c39f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bbf6abe92444accaab833d97a8429359e3abc57bd3f497ce39253dd96e320d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c5ae243dbc4d8a0f03175884a0e457d99f2cd20f71b21bdc9e69bf602c4f8fc"
    sha256 cellar: :any_skip_relocation, ventura:        "d5496f2c0aaadbe276f6bd6d5c576a95f02605a5cfa1f88786fa2cc92c7b99a4"
    sha256 cellar: :any_skip_relocation, monterey:       "d71f92a7c777eee857bc400258340d5e4f1e5179490acec79d2452244ce14d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5983f4a25419bf31dab2bb137062887e2dce3dfa0870d2332b3bafca36e06854"
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
    system "#{bin}/runme", "--version"
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
