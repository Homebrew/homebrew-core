class ZshHistorySubstringSearch < Formula
  desc "Zsh port of Fish shell's history search"
  homepage "https://github.com/zsh-users/zsh-history-substring-search"
  url "https://github.com/zsh-users/zsh-history-substring-search/archive/v1.0.1.tar.gz"
  sha256 "4de589fe54471f0c3449e74c8297b843ef57ce7d8c19d2cae4171a7d4021d85b"

  bottle :unneeded

  def install
    inreplace "README.md", "source zsh-history", "source #{opt_prefix}/zsh-history"
    prefix.install Dir["*.zsh"]
  end
end
