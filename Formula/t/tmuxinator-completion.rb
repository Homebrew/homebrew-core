class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "af5104c0beda911a8f263808ffb16e4438dbc755ee77bbf528d4bb46cac07a95"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  livecheck do
    formula "tmuxinator"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93630f3783e22aae47a9b1e1710d0088f4d78a5845c1008ad8cabd5d8d63ed83"
  end

  def install
    bash_completion.install "completion/tmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completion/tmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion/*.fish"]
  end

  test do
    assert_match "-F _tmuxinator",
      shell_output("bash -c 'source #{bash_completion}/tmuxinator && complete -p tmuxinator'")
  end
end
