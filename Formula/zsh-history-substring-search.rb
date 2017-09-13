class ZshHistorySubstringSearch < Formula
  desc "Zsh port of Fish shell's history search"
  homepage "https://github.com/zsh-users/zsh-history-substring-search"
  url "https://github.com/zsh-users/zsh-history-substring-search/archive/v1.0.1.tar.gz"
  sha256 "4de589fe54471f0c3449e74c8297b843ef57ce7d8c19d2cae4171a7d4021d85b"

  bottle :unneeded

  def install
    pkgshare.install "zsh-history-substring-search.zsh"
  end

  def caveats
    <<-EOS.undent
    To activate the history search, add the following at the end of your .zshrc:

      source #{HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

    You will also need to force reload of your .zshrc:

      source ~/.zshrc
    EOS
  end

  test do
    assert_match "i",
      shell_output("zsh -c '. #{pkgshare}/zsh-history-substring-search.zsh && echo $HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS'")
  end
end
