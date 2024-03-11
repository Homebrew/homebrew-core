class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "346c9707e043a02f953a55f8bd2c19cdaa773a04cf36925fd179e29fa366cfaa"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ba7aa36db877a7dfaa1f3fbcd4ffe76ae68a2c3f5e8f09d4317b5ab8e88d55c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5010d16b521c75020fc59b45f3a7e9276b6666370c08d57a79bd8d3b054cbd11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46b32f968bb54b76b51dbd760858a8ba0ea5782371c3a84f512aa16fe70eed72"
    sha256 cellar: :any_skip_relocation, sonoma:         "24ca1db16570fb7b6056e3abc41fa3111bc80315cc1be82bd0c887fac08ad99a"
    sha256 cellar: :any_skip_relocation, ventura:        "e7329c22ca6430a09cb67a96521bf184a817bf937bc968a66dea3e332e54481f"
    sha256 cellar: :any_skip_relocation, monterey:       "3fb0c7e6aced24026faa5205552bd7653e0b4a68e4e944979112ad5e0bd2147d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64615f3c1435f14b2c6e37f2202b34caff2b70153f788ee1aa45fe340a9b30f2"
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
