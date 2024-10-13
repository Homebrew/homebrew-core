class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "8b41f7c56b42ea13e37c99f4cd818a571859f473ae5acbed12f343a75e3fa1be"
  license "MIT"
  head "https://github.com/tmuxinator/tmuxinator.git", branch: "master"

  livecheck do
    formula "tmuxinator"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a156c049432e6a5b1af0b825db5feb7f323e1186750e000d4efbcfc5ddcfadc6"
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
