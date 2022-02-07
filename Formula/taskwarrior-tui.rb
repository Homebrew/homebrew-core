class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.19.0.tar.gz"
  sha256 "2d592ec6483fb62c33a496db7f203d7369528ebe647893a205063ad891968deb"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c26012933169aa68b4c050b7c05140d71d54f39d7fb939c428fc61eafa422ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d37772564354bd96771cec5686fad6e3a358c96ed1fb5e495f2c9c04e95a551"
    sha256 cellar: :any_skip_relocation, monterey:       "d91feec3204c2c531a91fa6d0017521f3773766e53483358ac1da84a3b78fef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "236a5a112d8f9212b773177a72277d49f96bb59c669486343a3b7b1f590207ca"
    sha256 cellar: :any_skip_relocation, catalina:       "b5c11c01ade6d20c7806cebe961ba6210d60543b50bb3cfda65a58fa474c12b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d74d9250360d16df6081e495fc27ba0f11aa1aa916da7433aacd3c3f993b95"
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
