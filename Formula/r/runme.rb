class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "963a2e1eca3e5550d0ecb9da03eec19b39474cd51956b8a30641f834f4d3af8f"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41aef47ca9464034651b2fbe15a2730e57de04ce5299a188f4b2bc5eed67d569"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a05e42b50380d74200d24331de4e2302f1070cf1fe7d7ae62f33642527f919c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d5fe16a2044bed74da051b9e30aebd3f1474e3b0df05d96a0a9d7cdfbaf6be4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bf1bf5ec11aca2f9fe53f716990a4b2a82c7e9a661d701f2f498bc0bed04779"
    sha256 cellar: :any_skip_relocation, ventura:        "92ee2ebb4a28687743e90740b59f1547e3dd62f3470d2e841cd7566db4555338"
    sha256 cellar: :any_skip_relocation, monterey:       "fb30c21807e490acf830dea4130518c6042e461a56047936117391c151db3c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f9d4d3651eeba109a6f93f844a99e60a9ab3fbcedea43484d59d0fa2770fe6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
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
