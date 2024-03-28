class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "3fc31f63714de9077adca7957cb2bb701c8b889b67dcad46d8a50eb77778e8c5"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dbaf2582c179121a3fb5f49e1d40f81921a89a115b355da7c1344e0dad37abd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "805e688099dd8a87174ea7fd056a19c20fcad9f6c1c738a34af6a22f868c422f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0430dfd22ebd406812faa659844d5d4f3c223548ba92e0d841c2c93bde52682"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee7f20351c5e46127df6e4b3ab689db9f5d6172100102b984935992072bf14ad"
    sha256 cellar: :any_skip_relocation, ventura:        "bf44551f8fa31c3769f9908c248fc3283ab8d5cd25b63d1cc55e2b9e9647181b"
    sha256 cellar: :any_skip_relocation, monterey:       "b4abd443a8414d7c7f1ef144a52b8f7f8f106b910d7c2a76f2ce5700603a9814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c99797236bb42871e5c9775236d8cce0d7965589edf42dd25e5fd7a2aa94664"
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
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
