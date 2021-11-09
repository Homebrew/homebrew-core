class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.9.tar.gz"
  sha256 "d185996570971697cd2b8103763135ed95768f3cbd7a133f52754bf7d2aef9d0"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6182f18e053358732c3726a8bacea87110d4420601cd1e2059f3d7d163a425e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aea9f9436c16d03bfd66e37fe947cdc705d59a06b5f34b85c296a070c67fd71a"
    sha256 cellar: :any_skip_relocation, monterey:       "ed38ba8dc16ac831a7e4da8c4da37c84010a747ad1459dd77bb7dcf4fd9ef62f"
    sha256 cellar: :any_skip_relocation, big_sur:        "df94009ff46b3039b479677b8b07e1c5382074d4d07f853732ebbc85b12f4233"
    sha256 cellar: :any_skip_relocation, catalina:       "14769e49ca035ca1d84db58fb66e4ba29da8d847258351e04baa3e081e897fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f183acbf357d47b6c50321d27bc7655c52b995b3ac504d5a941af78da55c60d"
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
