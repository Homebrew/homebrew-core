class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v2.0.3.tar.gz"
  sha256 "7ef03f8b23306944170b5951e7db280d1a1c3f1484fc292056f28185224634ab"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18bf3bab7756a16057c776f7f29db74c2a0c6ce2f37ec0534cdae64f26f59b72"
  end

  conflicts_with "tmuxinator", because: "the tmuxinator formula includes completion"

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
