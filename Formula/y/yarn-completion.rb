class YarnCompletion < Formula
  desc "Bash completion for Yarn"
  homepage "https://github.com/dsifford/yarn-completion"
  url "https://github.com/dsifford/yarn-completion/archive/v0.17.0.tar.gz"
  sha256 "cc9d86bd8d4c662833424f86f1f86cfa0516c0835874768d9cf84aaf79fb8b21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63d3cb7b4f3862462ef6097c56dfcae3a7a906f84747000856353279ea8ebebc"
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
