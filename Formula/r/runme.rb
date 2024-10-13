class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.8.4.tar.gz"
  sha256 "7f3123401b3b84a023a12334a940f74531732d9f1abe12bf8eda92f8ca192fd4"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb4c545d2d3bd2cfc8b3cf560ccccca8995aca5ba17d9861d03d720f895bf47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebb4c545d2d3bd2cfc8b3cf560ccccca8995aca5ba17d9861d03d720f895bf47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebb4c545d2d3bd2cfc8b3cf560ccccca8995aca5ba17d9861d03d720f895bf47"
    sha256 cellar: :any_skip_relocation, sonoma:        "80255518768c42ee08930486676280bfcfe7ff337838744f1230f25b9b031de4"
    sha256 cellar: :any_skip_relocation, ventura:       "80255518768c42ee08930486676280bfcfe7ff337838744f1230f25b9b031de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02fee37f510cb0b6446d69156ad73d5a92812ebe59cf66a0d1ca9401c6cdf229"
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
