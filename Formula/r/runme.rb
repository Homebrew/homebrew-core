class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "6c450ef0ea5ff3f14175bb9c5f6be7574b4572bc97168dc2be50a04304a6d4e5"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e99df9e84153d45675b25c785366078fbca0e887cff174ecd2d36759c3688f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e99df9e84153d45675b25c785366078fbca0e887cff174ecd2d36759c3688f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e99df9e84153d45675b25c785366078fbca0e887cff174ecd2d36759c3688f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0a97f08391b9f29cf121df051a47886bb5eae6721121741de3b4e6649b5e392"
    sha256 cellar: :any_skip_relocation, ventura:       "c0a97f08391b9f29cf121df051a47886bb5eae6721121741de3b4e6649b5e392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2b2064e62f7b2992af98c469f133e1db2d5cdaaf7fe3999a127e1c0d416070"
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
