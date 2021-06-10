class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.7.2.tar.gz"
  sha256 "992deee4a65608542a1b5ef696182bb91c4369d5603873b2f3fdde4e01210682"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dcbc3c62494c7c7bc318649d05b292bb8563f223fadcbdc33174a189439e8b1a"
    sha256 cellar: :any_skip_relocation, big_sur:       "70f0bd96532da44fd0023e09b211589cd4cac5e03af1cfad40192ab0319d6b9f"
    sha256 cellar: :any_skip_relocation, catalina:      "fca8f49ad413dbe4497fc1bc9dfe6b6ae22a3be3f79155476c7b186c270b2187"
    sha256 cellar: :any_skip_relocation, mojave:        "75c8e168cdbffe600e085ff8ad2117add1f6dcc250bf462ed39831d41e07adb9"
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
