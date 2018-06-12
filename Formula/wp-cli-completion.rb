class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  # Checksum mismatch for 1.5.1
  # See https://github.com/Homebrew/homebrew-core/pull/28579
  url "https://dl.bintray.com/homebrew/mirror/wpcli-completion-1.5.1.tar.gz"
  sha256 "4fdef45ab8e15438837b7d58f22e90ca66ce3c394f492bb26aa984b6ab2047b3"

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
