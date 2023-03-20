class ZshAutocomplete < Formula
  desc "Real-time type-ahead completion for Zsh"
  homepage "https://github.com/marlonrichert/zsh-autocomplete"
  url "https://github.com/marlonrichert/zsh-autocomplete/archive/refs/tags/22.01.21.tar.gz"
  sha256 "3e725a8f603796a87cc915d02f26736d967c828b3ec1335543991ca6cbb1b753"
  license "MIT"
  head "https://github.com/marlonrichert/zsh-autocomplete.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe7a87395db7c45ca43b46ea2a784e05d0610f3106ec74a300a7c8210c701627"
  end

  depends_on "clitest" => :test
  uses_from_macos "zsh" => :test

  def install
    pkgshare.install Dir["*"] + [".clitest"]
  end

  def caveats
    <<~EOS
      Installation
      1. Add at or near the top of your .zshrc file (before any calls to compdef):
        source #{HOMEBREW_PREFIX}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
      2. Remove any calls to compinit from your .zshrc file.
      3. If you're using Ubuntu, add to your .zshenv file:
        skip_global_compinit=1
      Then restart your shell.
      For more details, see:
        https://github.com/marlonrichert/zsh-autocomplete
    EOS
  end
  test do
    cd pkgshare do
      system "zsh", "./run-tests.zsh"
    end
  end
end
