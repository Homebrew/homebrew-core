class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/v2.6.0.tar.gz"
  sha256 "72b4b49331a5a0cba78c3460106a4dbc741cae313fd1654c52ef0113c7c15b4a"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "734edec409917971c5e8f734bf3286574ce15b17e19e858e1517227185f8ec6a"
  end

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
