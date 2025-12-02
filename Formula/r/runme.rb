class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.4.tar.gz"
  sha256 "87ef443f92d00cbc2e36cb280fcf97a1a8976ff22fa17f8423053ac7082ceb74"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e050326a5423e9431f29484248cc84288d0c3b825128bbf82854fe934fa4e998"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ad19d188ddeb414a179fe2fc2e7df1790cdc22d659b460fc9c58e278739cbb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c15e937aa6b30520e1d6cb3611cb125f6029c7d0de9f0e97f3506865cdb51138"
    sha256 cellar: :any_skip_relocation, sonoma:        "600b33c18aec2bb949846631263cf05e5881c89540d287c028cfc1ac3c2fe67b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d38c86df1772ce5871b0c70ccc7446eca2b2bbd900e81279683239e28badaf3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2086c6fce6f2c6ca52a98bb48aaaf4d5c004ed1227ea3b75f5bd4cb1718df367"
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
