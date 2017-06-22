class WpcliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/v1.2.1.tar.gz"
  sha256 "7919d28dc3570696d2971ded5a14701da7cc10ffcc87935b781c28e1601bdffb"

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
