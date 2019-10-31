class YarnCompletion < Formula
  desc "Bash completion for Yarn"
  homepage "https://github.com/dsifford/yarn-completion"
  url "https://github.com/dsifford/yarn-completion/archive/v0.15.0.tar.gz"
  sha256 "4f350f50e85d4d47c67677a35b8a67950d0193a324b0c932c320831c7834f73a"

  bottle :unneeded

  conflicts_with "bash-completion", :because => "Bash v4+ & bash completion v2 are required"

  def install
    bash_completion.install "yarn-completion.bash" => "yarn"
  end

  test do
    assert_match "complete -F _yarn yarn",
      shell_output("bash -c 'source #{bash_completion}/yarn && complete -p yarn'")
  end
end
