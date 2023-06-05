class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "483bb6692bdfb4a5f995500e35dccde9117c033f6c85ec4eb169fc6952f458fc"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d0832bc22a2fd5b786440e414173ab8ece0bd087c356e2111fa1e1b157c6ca9d"
  end

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("bash -c 'source #{bash_completion}/wp && complete -p wp'")
  end
end
