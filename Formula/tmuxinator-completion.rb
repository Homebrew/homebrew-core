class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v2.0.1.tar.gz"
  sha256 "a2c8428d239a6e869da516cecee3ac64db47ba1f1932317eb397b1afd698ee09"
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
