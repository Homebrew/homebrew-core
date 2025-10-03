class TCompletion < Formula
  desc "Completion for CLI power tool for Twitter"
  homepage "https://sferik.github.io/t/"
  url "https://github.com/sferik/t-ruby/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "3053ce8983ee673c6975bca7235cebea3eeb9bdfa7c5644d44cb7ad6fd9aaf9b"
  license "MIT"
  head "https://github.com/sferik/t-ruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dac644293e51a204dd1df5d419678a5d1e59f9ea2475d5308cd658aba3cb6faa"
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
