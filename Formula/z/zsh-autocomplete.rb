class ZshAutocomplete < Formula
  desc "Real-time type-ahead completion for Zsh"
  homepage "https://github.com/marlonrichert/zsh-autocomplete"
  url "https://github.com/marlonrichert/zsh-autocomplete/archive/refs/tags/24.09.04.tar.gz"
  sha256 "bfcaa4b2d3add07c6b3d5a587d9ed743e091f1bb8e818cbd157895376edf2e87"
  license "MIT"
  head "https://github.com/marlonrichert/zsh-autocomplete.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cbbda374b4344389d0518702923772f7e445de5c4a1426d5c1184a353e191735"
  end

  depends_on "clitest" => :test
  uses_from_macos "zsh" => :test

  def install
    pkgshare.install Dir["*"]
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
    (testpath/"run-tests.zsh").write <<~EOS
      #!/bin/zsh -f

      env -i HOME=$HOME PATH=$PATH FPATH=$FPATH zsh -f -- \
          =clitest --progress dot --prompt '%' -- $PWD/Tests/*.md
    EOS
    cd pkgshare do
      system "zsh", testpath/"run-tests.zsh"
    end
  end
end
