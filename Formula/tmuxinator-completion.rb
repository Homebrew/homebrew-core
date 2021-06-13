class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v3.0.0.tar.gz"
  sha256 "0e0f28522d6a945b45805026148399708807377cc9b9f03d27e0bfc44a4cefb9"
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
