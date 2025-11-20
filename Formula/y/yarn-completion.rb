class YarnCompletion < Formula
  desc "Bash completion for Yarn"
  homepage "https://github.com/dsifford/yarn-completion"
  url "https://github.com/dsifford/yarn-completion/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "cc9d86bd8d4c662833424f86f1f86cfa0516c0835874768d9cf84aaf79fb8b21"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e743fe4680eb970207cd4a05ec2f2482f1c3baf96ae04827b75bffb29afd78be"
  end

  depends_on "bash"

  def install
    bash_completion.install "yarn-completion.bash" => "yarn"
  end

  test do
    assert_match "complete -F _yarn yarn",
      shell_output("#{Formula["bash"].opt_bin}/bash -c 'source #{bash_completion}/yarn && complete -p yarn'")
  end
end
