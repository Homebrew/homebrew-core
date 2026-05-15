class TCompletion < Formula
  desc "Completion for CLI power tool for Twitter"
  homepage "https://sferik.github.io/t/"
  url "https://github.com/sferik/t-ruby/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "30685de7d87d385a1c74b6ef47732c8b5259fe50f434efd651757e5529cc2fe9"
  license "MIT"
  head "https://github.com/sferik/t-ruby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f41fb3b6dcda43958db52bea7f259cddd0272735e4f09eafa61a01637ac9b9d"
  end

  def install
    bash_completion.install "legacy/etc/t-completion.sh" => "t"
    zsh_completion.install "legacy/etc/t-completion.zsh" => "_t"
  end

  test do
    assert_match "-F _t",
      shell_output("bash -c 'source #{bash_completion}/t && complete -p t'")
  end
end
