class Timeout < Formula
  desc "Run a command with a time limit"
  homepage "https://github.com/leecade/timeout"
  url "https://github.com/leecade/timeout/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "113cd3caca369a25abf293ee31d6b6fc699ccfa4ea0aa200c968b7d65badb529"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completions/timeout.bash"
    zsh_completion.install "completions/timeout.zsh" => "_timeout"
    fish_completion.install "completions/timeout.fish"
  end

  test do
    assert_match(/timeout/, shell_output("#{bin}/timeout --version 2>&1"))
    output = shell_output("#{bin}/timeout 1 sleep 2; echo $?").chomp
    assert_equal "124", output
  end
end
