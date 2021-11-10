class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.14.tar.gz"
  sha256 "36fcf90e9f0ffbc3d7fedfd094de80dffe6775d77f81c9612de9bd6b70e577a6"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2598cf480fea0d339144c782fbe44361bf6ade179406abc2c37abf9986592ff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d07daa2cfbcc623f06b8e4a2849dc2e64b0145ae9560c7bf863871e26f53fe5"
    sha256 cellar: :any_skip_relocation, monterey:       "245435c339ba6a66db574ef1a1d68108dbb9e5f625e996dfc5ef3f333a852d63"
    sha256 cellar: :any_skip_relocation, big_sur:        "03dce6023540df08d103c8d0d9a7e084b2f88520771d9f27737babab6fe9b7c2"
    sha256 cellar: :any_skip_relocation, catalina:       "d7ddcb4dfac15d692ce80d634f538dad000cda6dd0611627d424cbc9b3335841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97de00cb777d3917789f74b982253d1d24447fb5a3627a96ee914045a42d50f7"
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
