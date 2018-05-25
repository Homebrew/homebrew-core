class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v0.11.2.tar.gz"
  sha256 "468d3485cc9fc9ad2b53875b7418c5dbcdfe758a2777a2852dd3037b15828808"

  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle :unneeded

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
