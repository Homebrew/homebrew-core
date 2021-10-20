class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.34.tar.gz"
  sha256 "6d5c5a67420204f603e61054382fb39432098fd2daa758029b5ac848a9356024"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f521dc2b7ca87148f47822e726927c9c1e575cf0793eb7050e6a687035d3201d"
    sha256 cellar: :any_skip_relocation, big_sur:       "197bc9a387b5752f1b84db88a16b7ebba69161b7724dd22676075557cd79efe7"
    sha256 cellar: :any_skip_relocation, catalina:      "ac8aea1c340f56da67d7f96c1d1be8e1255bf15ac1c0b0cd406f6ce952015c61"
    sha256 cellar: :any_skip_relocation, mojave:        "d22296faf0a3da4788b045a78ba4f74b824671613c17fe40b3f7e13ce08a3d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95c1222fbb2992322127e066e10cc954ff33a1fbbbd41997b48b07cf1f31cb48"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
    man1.install "taskwarrior-tui.1"

    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--report <STRING>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
