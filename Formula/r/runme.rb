class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.9.3.tar.gz"
  sha256 "7a1a68cde2ceeef1b3873b33a7407c874649852f7c3ab48c9092e0544a0b53c7"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fccd65b5139974fc28aa0a5adbe7614a53323d1499cbdd3fe9522e82d7d3365"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fccd65b5139974fc28aa0a5adbe7614a53323d1499cbdd3fe9522e82d7d3365"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fccd65b5139974fc28aa0a5adbe7614a53323d1499cbdd3fe9522e82d7d3365"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b09b98d14b575371468d011d549298a7df647969bb9cc5d94087474167c720"
    sha256 cellar: :any_skip_relocation, ventura:       "23b09b98d14b575371468d011d549298a7df647969bb9cc5d94087474167c720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09cffc9b7bc9047f1e31ba629ad15d41a0b7194776db406a006f51b8e4b65f96"
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
    system bin/"runme", "--version"
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
