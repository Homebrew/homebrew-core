class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "346c9707e043a02f953a55f8bd2c19cdaa773a04cf36925fd179e29fa366cfaa"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "257621af6b9d6334d707e046282fa5d7c559be5a84372277d67fc12101677742"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1186c6ebaaf70c223d38f7c70ef2d79f6910f36c59c629a8cab2c520c09c13c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "990e334d4e6a4cacc66a7811f4a1ca15f30f432e13e82ef95b0d6e3cbebbe94e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8acddaa59ae5d65b6ca51da80f17ad435ff516d68a5d29c648c904ac4aa12e9"
    sha256 cellar: :any_skip_relocation, ventura:        "1efc605918f46e86cd3a2da10945873848444b8858b0740c47c150bd69f7c451"
    sha256 cellar: :any_skip_relocation, monterey:       "288fa36bbc844cf29d845f49e93822a5e3cbcdf6728a4f8416a5a020b9dd7e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da0f22a7201afab4ecd501641294e94081118f8226627dafc1f499d7307c5a7"
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
