class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "13ac74b1d55c20a365debe7866dd2bd287f2c7f43b0bd1162d114c1216873de7"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebe4176a567953007fe170952c4660c3f3a651d7df5912a4ee091ab83a0bd927"
  end

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
