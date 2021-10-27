class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.35.tar.gz"
  sha256 "0ee73a172e185057241fb2d3bc6c1c229d541d7ce2d72cb3a36181599e6039e2"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2311559f0e161469edd883ab769f3e1428e67bdede027c1fd89cb02f573b6361"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfe1792af1136738e64469271704f10d276b119e540671ee3b91ac861a629977"
    sha256 cellar: :any_skip_relocation, monterey:       "1617bcbe296e3c05398fdd184b817ac329ae573a4faa3955af6856c254f69d6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "df6de52cdb7b459e9e23b1e757704a73d8eb02964279a09bd8044f24a815d590"
    sha256 cellar: :any_skip_relocation, catalina:       "fd205b45e96549770d3d81d2f3102ef328e3dad527b30c84cd0d115a96413501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61bce50cf7579efe8fbe0d1d7bab36f9821f0dac4f50de5b98e908fc411f6473"
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
