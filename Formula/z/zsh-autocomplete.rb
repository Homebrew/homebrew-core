class ZshAutocomplete < Formula
  desc "Real-time type-ahead completion for Zsh"
  homepage "https://github.com/marlonrichert/zsh-autocomplete"
  url "https://github.com/marlonrichert/zsh-autocomplete/archive/refs/tags/25.03.19.tar.gz"
  sha256 "866451178e35b50f7f86a6b50d8cdb28494bb3a7be02b1c7adf909390a9774fb"
  license "MIT"
  head "https://github.com/marlonrichert/zsh-autocomplete.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2293efac410eae4220f21942481793ad9b13376b83f0f3225f90e0d5d8e305b"
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
    (testpath/"run-tests.zsh").write <<~SHELL
      #!/bin/zsh -f

      env -i HOME=$HOME PATH=$PATH FPATH=$FPATH zsh -f -- \
          =clitest --progress dot --prompt '%' -- $PWD/Tests/*.md
    SHELL

    cd pkgshare do
      system "zsh", testpath/"run-tests.zsh"
    end
  end
end
