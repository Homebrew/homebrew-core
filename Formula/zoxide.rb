class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.8.2.tar.gz"
  sha256 "3a977960284bc06f3c7f02ec93b6f269fd9f5bf933115828e6f46cf6c2601f5e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17b9866b8538f7c106137df3aedf78fe227893c5d7536a065b563b1bf7314cc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "933ace32800c0d1980159c8220a3e9b097a505c3131ebfcc728a51e8a9d7b0c3"
    sha256 cellar: :any_skip_relocation, monterey:       "df0711110ded8e845e73ed7d5290bd9559d366e6882068417afbf7d8ac013563"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2d7264be887ddc03b8b1de9a3b3625e5b1ac63d400bffae41616b624b8e1fc0"
    sha256 cellar: :any_skip_relocation, catalina:       "92894d5bf6376124fcc07992946e879849efdde1bc43f28bd45d87546518da46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866927ab09b1a26d41659e2aeed76fbd8d719da32cc97137d72316d90175f7d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
