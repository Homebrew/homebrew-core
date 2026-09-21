class ZshAutocomplete < Formula
  desc "Real-time type-ahead completion for Zsh"
  homepage "https://github.com/marlonrichert/zsh-autocomplete"
  url "https://github.com/marlonrichert/zsh-autocomplete/archive/refs/tags/26.08.04.tar.gz"
  sha256 "57713aee4231e367b8947d715e8fa3cf2c274fb2f7c1e027e59005a2db34a914"
  license "MIT"
  head "https://github.com/marlonrichert/zsh-autocomplete.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "366ffd368038c06ca0d227d83a53db82d0629948a7133dd531f837538f4afc6d"
  end

  depends_on "clitest" => :test
  uses_from_macos "zsh" => :test

  deny_network_access!

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
