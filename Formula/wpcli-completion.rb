class WpcliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/v1.4.0.tar.gz"
  sha256 "fa7a349db23969709b50f389b18efbde48fc7903939acb99452508f4b5221bbd"

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
