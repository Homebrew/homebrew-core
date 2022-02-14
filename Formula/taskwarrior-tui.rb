class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.19.2.tar.gz"
  sha256 "de0d6cbae12d7ace7f6c5ea767d211777a0bba7f826f9abdf35d9a42484b2017"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "285f13c6ec9253eb70e3a96fd0ef22097bf90f69883435bdea6022ea117759f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55391011651c8fdd9e38dbc88623d9827d8bdcc0b94629d25f998ea92bdeff9f"
    sha256 cellar: :any_skip_relocation, monterey:       "fa09b4a3040fe1bcdc413e907c66cda3ff114ce9890a2c971dc921af19d690c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bebd1c490ad75f16cf2fe0644dfd5e6b69c83c0b84f99c1a6fec2852c394afc5"
    sha256 cellar: :any_skip_relocation, catalina:       "ee0475153f89dae5c46d2f8b45ff66af13f85144946e34632bdc6dc496ae0d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2a4ad235c1f70635bf07255dcf7e0abedb3abb8691db2046c2d88769d9b58ee"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
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
