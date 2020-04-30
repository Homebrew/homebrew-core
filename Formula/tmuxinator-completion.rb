class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v2.0.0.tar.gz"
  sha256 "83e50381fbdb224dbc214249c34af7ede912445bfc4eff20fdb88a8052404e09"
  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle :unneeded

  conflicts_with "tmuxinator", :because => "the tmuxinator formula includes completion"

  def install
    bash_completion.install "completion/tmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completion/tmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion/*.fish"]
  end

  test do
    assert_match "-F _tmuxinator",
      shell_output("source #{bash_completion}/tmuxinator && complete -p tmuxinator")
  end
end
