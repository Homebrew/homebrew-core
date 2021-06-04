class ZshHistorySubstringSearch < Formula
  desc "Zsh port of Fish shell's history search"
  homepage "https://github.com/zsh-users/zsh-history-substring-search"
  url "https://github.com/zsh-users/zsh-history-substring-search/archive/v1.0.2.tar.gz"
  sha256 "c1bb21490bd31273fb511b23000fb7caf49c258a79c4b8842f3e1f2ff76fd84c"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "556fffc8eceb018b5079b6e4ff3b152e7223b4f5f9416d1d210409aceabf4203"
  end

  def install
    pkgshare.install "zsh-history-substring-search.zsh"
  end

  def caveats
    <<~EOS
      To activate the history search, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

      You will also need to force reload of your .zshrc:

        source ~/.zshrc
    EOS
  end

  test do
    assert_match "i",
      shell_output("zsh -c '. #{pkgshare}/zsh-history-substring-search.zsh && " \
                   "echo $HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS'")
  end
end
