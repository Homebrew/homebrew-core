class TCompletion < Formula
  desc "Completion for CLI power tool for Twitter"
  homepage "https://sferik.github.io/t/"
  url "https://github.com/sferik/t-ruby/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "998a884aa5dcd024617427c8cee7574eb3ab52235131bb34875df794b8c3c7d7"
  license "MIT"
  head "https://github.com/sferik/t-ruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28d1c8535510ece370a91e8935cdf98e0a0f032f8d7c6a8b8c4ea65641cc5c22"
  end

  def install
    bash_completion.install "etc/t-completion.sh" => "t"
    zsh_completion.install "etc/t-completion.zsh" => "_t"
  end

  test do
    assert_match "-F _t",
      shell_output("bash -c 'source #{bash_completion}/t && complete -p t'")
  end
end
