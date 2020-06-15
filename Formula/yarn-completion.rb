class YarnCompletion < Formula
  desc "Bash completion for Yarn"
  homepage "https://github.com/dsifford/yarn-completion"
  url "https://github.com/dsifford/yarn-completion/archive/v0.16.0.tar.gz"
  sha256 "ec2f949a0b283bd7d99e8a3320c84afbac19a885a0d3c3b34909dfe3fa9bb09d"

  bottle :unneeded

  def install
    bash_completion.install "yarn-completion.bash" => "yarn"
  end

  test do
    assert_match "complete -F _yarn yarn",
      shell_output("source #{bash_completion}/yarn && complete -p yarn")
  end
end
