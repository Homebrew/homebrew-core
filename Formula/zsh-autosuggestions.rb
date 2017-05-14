class ZshAutosuggestions < Formula
  desc "Fish-like fast/unobtrusive autosuggestions for zsh."
  homepage "https://github.com/zsh-users/zsh-autosuggestions"
  url "https://github.com/zsh-users/zsh-autosuggestions/archive/v0.4.0.tar.gz"
  sha256 "39cc5e3976e7928ff12f1cf5fa3108c790f8f6ad8eacf71cfc0b302931bc8308"

  bottle :unneeded

  def install
    zsh_function.install "zsh-autosuggestions.zsh" => "zsh-autosuggestions"
  end

  def caveats
    <<-EOS.undent
    To activate the autosuggestions, add the following at the end of your .zshrc:

      autoload -Uz zsh-autosuggestions && zsh-autosuggestions

    You will also need to force reload of your .zshrc:

      source ~/.zshrc
    EOS
  end

  test do
    assert_match "default",
      shell_output("zsh -c 'autoload -Uz zsh-autosuggestions && zsh-autosuggestions && echo $ZSH_AUTOSUGGEST_STRATEGY'")
  end
end
