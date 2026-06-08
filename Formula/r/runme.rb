class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.11.tar.gz"
  sha256 "ab4bcdcb7404b5d903fe0f5a38bcf9d5c6532471b9839937146dde575da72ebf"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8884e841f796d8d3714aa5f5db7407c781331f31ac63f1e00c454a1503dfb00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7a4aed2504454d3b97c390281a387bd27a7de10fa00ce22a9331f5e4415e935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "143fc5163cd66cd81d32276c9aa4843e7259ce32f9603bee38a135ab0c862837"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f86528b280f4c0cad096f7987b005bd9091c46da6b3fb1b7b754bad811c1675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db48bb92ad412cb2ec6c20540812f99c45d70446190ea5a3fc5a62999df86f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d8a832558c09b29edeb6331cf2c388adc4847dae56537281c565ec52892e9f7"
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
    generate_completions_from_executable(bin/"runme", shell_parameter_format: :cobra)
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
