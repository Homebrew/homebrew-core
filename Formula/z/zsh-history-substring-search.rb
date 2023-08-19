class ZshHistorySubstringSearch < Formula
  desc "Zsh port of Fish shell's history search"
  homepage "https://github.com/zsh-users/zsh-history-substring-search"
  url "https://github.com/zsh-users/zsh-history-substring-search/archive/v1.1.0.tar.gz"
  sha256 "9b52eca6c894dd98caa5f07160199f3f3179ff017575d5acc9fdc467b1ac70f8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "389dd56ef87f77caff258d05baa26c20adbc586e6afa6bf2520c1c47c7095485"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "389dd56ef87f77caff258d05baa26c20adbc586e6afa6bf2520c1c47c7095485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "389dd56ef87f77caff258d05baa26c20adbc586e6afa6bf2520c1c47c7095485"
    sha256 cellar: :any_skip_relocation, ventura:        "389dd56ef87f77caff258d05baa26c20adbc586e6afa6bf2520c1c47c7095485"
    sha256 cellar: :any_skip_relocation, monterey:       "389dd56ef87f77caff258d05baa26c20adbc586e6afa6bf2520c1c47c7095485"
    sha256 cellar: :any_skip_relocation, big_sur:        "389dd56ef87f77caff258d05baa26c20adbc586e6afa6bf2520c1c47c7095485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6975d72e0b087069583d9e515248371780264481a106a2ec491cbc11945d6e"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "zsh-history-substring-search.zsh"
  end

  def caveats
    <<~EOS
      To activate the history search, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match "i",
      shell_output("zsh -c '. #{pkgshare}/zsh-history-substring-search.zsh && " \
                   "echo $HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS'")
  end
end
