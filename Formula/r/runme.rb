class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "055b00cdc694093d56042a5467b88bdcbb8acee95f93e0d9be5bc521268da93c"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ff738683d1862a058348e342f8bcbbf38beb15c5681fa41bc76c9c81c626ede"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0416a413d4543136bd974fc2a42073e0e900bff4d44c931716b3fdf47d1df391"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9106d6cf2866b23a8c57d64a9806c95ed0a3baa936207a88af0bd6669804f936"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2229f412c4de666ff82e5411e3c457c4137ccd29a06663ab59578b6793ec3a1"
    sha256 cellar: :any_skip_relocation, ventura:        "8d67ba7ea077ad5dc23ff64309b0279d09bda33a7fabcdc5217cc80fa15a89ca"
    sha256 cellar: :any_skip_relocation, monterey:       "2373a9498c1be01864cda20060dbd689f0c8592460465f7ea6a546a77428a6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d2cbdac362bbdeef3940bf090f62f1734e230ce3d737f0fdcccab2005ce7ca4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
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
