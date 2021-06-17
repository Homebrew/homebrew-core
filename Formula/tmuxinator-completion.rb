class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v3.0.1.tar.gz"
  sha256 "1d79dd13beaaf2ed24c8a76410c1a41bedc7785498e199534fa3928bbf8aab01"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04cc6188159ca13ace4c51b4f8f5c4b8525039ad94ae9b8f48bc0747567c3cd5"
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
