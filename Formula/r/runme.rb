class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.17.8.tar.gz"
  sha256 "7b85f20325e7f98037b9a8182e729e01aa2aa2023b16e8dd11c95edc47adc129"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5732723d0eff86158b12eeecce54c5b445be531d8b91fa7c1239c0c7cc7a8cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e953aaec32caae4385b21df76ead1eb211c4198e4e5fc824c791a5c25c1c77b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a68cb4c5dc5cb26661830b086261a42616f0032dbab31bdf104c95006cd0f723"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bfdb3784d857b3829e280aedcaa32217f31c62305a7617023cc0c3779573b750"
    sha256 cellar: :any,                 x86_64_linux:      "207ecf078edae3ece71c8b64bba99b1ecd30a7164d87f1bce1ec78367c249c85"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
