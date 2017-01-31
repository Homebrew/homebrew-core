class WpcliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/v1.0.0.tar.gz"
  sha256 "7fd238e93ff24ee417a40aa5e147545e8859f386a1c106e251ce34ca8dd84b15"

  head "https://github.com/wp-cli/wp-cli.git"

  bottle :unneeded

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("source #{bash_completion}/wp && complete -p wp")
  end
end
