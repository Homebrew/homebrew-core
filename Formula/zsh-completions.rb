class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.33.0.tar.gz"
  sha256 "39452d383d0718aa2c830edba1aa32f0ee1e40002ef6932d88699a888bd58c29"
  license "MIT-Modern-Variant"
  head "https://github.com/zsh-users/zsh-completions.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2579cab8a4d96ce2a7d179bf36fb2898d4f3611823c6392f5eac2014ff4d7d1f"
  end

  def install
    inreplace "src/_ghc", "/usr/local", HOMEBREW_PREFIX
    zsh_completion.install Dir["src/*"]
  end

  def caveats
    <<~EOS
      To activate these completions, add the following to your .zshrc:

        autoload -Uz compinit
        compinit

      You may also need to force rebuild `zcompdump`:

        rm -f ~/.zcompdump; compinit

      Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
      to load these completions, you may need to run this:

        chmod -R go-w '#{HOMEBREW_PREFIX}/share/zsh'
    EOS
  end

  test do
    (testpath/"test.zsh").write <<~EOS
      autoload _ack
      which _ack
    EOS
    assert_match(/^_ack/, shell_output("/bin/zsh -fd test.zsh"))
  end
end
