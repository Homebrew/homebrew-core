class TCompletion < Formula
  desc "Completion for CLI power tool for Twitter"
  homepage "https://sferik.github.io/t/"
  url "https://github.com/sferik/t/archive/v4.0.0.tar.gz"
  sha256 "82e4afa54015c2297854854490be8dd3a09d7c99ed5af3f64de6866bb484ddde"
  license "MIT"
  head "https://github.com/sferik/t.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4000f3501fea5f4c7b817a5f83f35b6d7a2a864a8b665e0850b2e9da45cd389"
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
