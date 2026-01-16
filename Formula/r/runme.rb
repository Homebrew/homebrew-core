class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.4.tar.gz"
  sha256 "87ef443f92d00cbc2e36cb280fcf97a1a8976ff22fa17f8423053ac7082ceb74"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80483d4dead6b2f4caeee0c7af857cff2408808dd7d124a57e76275d31af6576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d74dc405ac76ef67f146205e5d54c57b4ec598a378f404212508a548a7a6f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e438080e3cd1e7c993bc1be5a37c4b86941976c116effd509fc48ade9e2409aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "17805a2fe646afc3d65083651973b93b2f79d53691915abf07c5757a1917fecc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a9cee8275ba783d5a94f05d13961cd1cfba7d001f8fc436d141ac2156bb1f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af4d23d42c8f4f734eaf88bb6cfcb0370ad031c59174907c729095d2edc9583e"
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
